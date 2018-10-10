class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :read, to: :see
    alias_action :update, to: :change

    send("#{user.role?}_abilities", user)
  end

  def admin_abilities(_user)
    can :manage, :all
  end

  def manager_abilities(user)
    user_abilities(user)
    can :see, :all
    can [:update], Song
    can [:update], Album
  end

  def user_abilities(user)
    can :see, :all
    can [:create, :change], User, id: user.id
    can [:create, :change, :delete], Playlist, owner: user
    can [:delete], Rating, created_by: user
    can :rate, :item if user.role?
  end

  def to_list
    rules.map do |rule|
      object = { actions: rule.actions, subject: rule.subjects.map { |s| s.is_a?(Symbol) ? s : s.name } }
      object[:conditions] = rule.conditions unless rule.conditions.blank?
      object[:inverted] = true unless rule.base_behavior
      object
    end
  end
end
