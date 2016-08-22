class UserPolicy < ApplicationPolicy

  def edit?
    user.present? && record == user
  end
end
