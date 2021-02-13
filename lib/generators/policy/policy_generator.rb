# frozen_string_literal: true

class PolicyGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)
  def create_policy_file
    create_file "app/policies/#{file_name}_policy.rb", <<~FILE
      # frozen_string_literal: true

      class #{class_name}Policy < ApplicationPolicy

      end
    FILE
  end
end
