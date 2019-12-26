# frozen_string_literal: true

#
# This class handles User authorization. So far this is roughly the same as AppPolicy
#
class UserPolicy < ApplicationPolicy
  def index
    super || admin?
  end

  def new
    super || admin?
  end

  def create
    super || admin?
  end

  def edit
    super || admin? && !admin_group?(record)
  end

  def update
    super || admin? && !admin_group?(record)
  end

  def destroy
    super || admin? && !admin_group?(record)
  end

  class Scope < Scope
    def resolve
      return scope.all if user.has_role?(:superadmin) || user.has_role?(:admin)

      scope.none
    end
  end
end
