class CommentPolicy < ApplicationPolicy

    def new?
      user.present? && user.admin?
    end

    def create?
      new?
    end

    def edit?
      user.present? && record.user == user || user_has_power?
    end

    def update?
      new?
    end

    def destroy?
      user.present? && record.user == user || user_has_power?
    end

    private

    def user_has_power?
      user.admin? || user.moderator?
    end

  end
