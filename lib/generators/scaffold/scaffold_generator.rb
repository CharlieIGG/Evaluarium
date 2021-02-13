# frozen_string_literal: true

require 'rails/generators/rails/scaffold/scaffold_generator'

module Rails
  module Generators
    class ScaffoldGenerator
      def run_other_generators
        generate 'policy', class_name
        add_to_model_translations
      end

      private

      def add_to_model_translations
        append_to_file('config/locales/activerecord/models.en.yml') do
          <<-CONTENT
      #{singular_table_name}:
        one: #{singular_table_name.titleize}
        other: #{plural_table_name.titleize}
        ui_description: Here you can manage #{plural_table_name.titleize} [CHANGE ME AT 'config/locales/activerecord/models']
          CONTENT
        end
      end
    end
  end
end
