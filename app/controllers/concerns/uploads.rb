module Concerns
  module Uploads
    extend ActiveSupport::Concern

    def upload_file
      load_resource.upload_resource
    end

    def delete_file
      load_resource.delete_resource
    end

    def load_resource
      CloudinaryServices.new(item_options)
    end

    def item_options
      {
        url: url,
        upload_type: resource_type,
        resource_options: resource_option
      }
    end

    def resource_type
      params[:type] == 'song' ? 'song' : 'image'
    end
  end
end
