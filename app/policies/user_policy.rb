# frozen_string_literal: true

#
# This class handles User authorization. So far this is roughly the same as AppPolicy
#
class UserPolicy < ApplicationPolicy
  def index
    super || user.has_role?(:admin)
  end

  def new
    super || user.has_role?(:admin)
  end

  def create
    super || user.has_role?(:admin)
  end

  def edit
    super || (user.has_role?(:admin) && !(record.has_role?(:superadmin) || record.has_role?(:admin)))
  end

  def update
    super || (user.has_role?(:admin) && !(record.has_role?(:superadmin) || record.has_role?(:admin)))
  end

  def destroy
    super || (user.has_role?(:admin) && !(record.has_role?(:superadmin) || record.has_role?(:admin)))
  end
end
