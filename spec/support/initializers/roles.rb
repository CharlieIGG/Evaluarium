# frozen_string_literal: true

#
# Helps manage roles for already existing users on-the-fly during specs.
#
module SpecRoleMacros
  #
  # Overrides the current_user's roles
  #
  # @param [Array] roles an array of roles with the shape `{ name: string|symbol, resource?: ApplicationRecord(abstract)}`.
  # Pass an empty array to remove all roles.
  #
  def current_user_roles!(roles = [])
    before(:all) do
      current_user.roles = []
      roles.each { |role| current_user.add_role role[:name].to_sym, role[:resource] }
    end
  end
end

RSpec.configure do |config|
  %i[request system].each do |spec_type|
    config.extend SpecRoleMacros, type: spec_type
  end
end
