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

  def superadmin?
    user.has_role? :superadmin
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user.person
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
