# frozen_string_literal: true

#
# This class handles global authorization. Resource-specific classes inherit <
#
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    superadmin?
  end

  def show?
    superadmin?
  end

  def create?
    superadmin?
  end

  def new?
    superadmin?
  end

  def update?
    superadmin?
  end

  def edit?
    superadmin?
  end

  def destroy?
    superadmin?
  end

  def superadmin?(target = user)
    target.has_role? :superadmin
  end

  def admin?(target = user)
    target.has_role?(:admin)
  end

  def admin_group?(target = user)
    superadmin?(target) || admin?(target)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.all if user.has_role?(:superadmin)

      scope.none
    end
  end
end
