class UserPolicy < ApplicationPolicy

  def new?
    user.present?
  end

  def create?
    new?
  end

  def edit?
    user.present? && record == user
  end

  def update?
    edit?
  end

  def destroy?
    edit? || user_has_power
  end

  private

  def user_has_power?
    user.admin? || user.moderator?
  end
end
