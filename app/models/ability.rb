class Ability
  include CanCan::Ability

  def initialize user
    can %i(read), Food

    return unless user

    unless user.role?
      can :manage, User, id: user.id
      can %i(read create update), Order, user_id: user.id
    end
    can :manage, :all if user.role?
  end
end
