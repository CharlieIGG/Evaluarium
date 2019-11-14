# frozen_string_literal: true

#
# This class will handle authorization to NilClass resources
#
class NilClassPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotDefinedError, 'Cannot scope NilClass'
    end
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    false
  end

  def edit?
    false
  end

  def update?
    false
  end

  def create?
    false
  end

  def destroy?
    false
  end
end
