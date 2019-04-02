class RestaurantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  # def new?
  #   create?
  # end

  # everyone can add a restaurant
  def create?
    true
  end

  # only the owner can update and edit the restaurant
  def update?
    # record is @restaurant
    # user is current_user
    is_owner_or_admin?
  end

  def destroy?
    is_owner_or_admin?
  end

  private

  def is_owner_or_admin?
    record.user == user || user.admin
  end
end
