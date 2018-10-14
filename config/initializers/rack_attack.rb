module Rack
  class Attack
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    whitelist('allow-localhost') do |req|
      req.ip == '127.0.0.1' || req.ip == '::1'
    end

    throttle('req/ip', limit: 4, period: 2.minutes) do |req|
      if req.path.include?('/auth')
        req.ip
      end
    end

    throttle('req/email', limit: 4, period: 2.minutes) do |req|
      if req.path.include?('/auth')
        req.params[:email]
      end
    end

    # Send the following response to throttled clients
    self.throttled_response = lambda { |env|
      retry_after = (env['rack.attack.match_data'] || {})[:period]
      [
        429,
        { 'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s },
        [{ error: 'Throttle limit reached. Retry later.' }.to_json]
      ]
    }
  end
end
