# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user, controller_namespace = nil
    case controller_namespace
    when "Admin"
      can :manage, :all if user.admin?
    else
      return unless user

      can :manage, Order, user_id: user.id
      return unless user.admin?

      can :manage, Order
    end
  end
end
