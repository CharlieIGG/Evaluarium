# frozen_string_literal: true

require 'rails/generators/rails/scaffold/scaffold_generator'

module Rails
  module Generators
    class ScaffoldGenerator
      def run_other_generators
        generate 'policy', class_name
      end
    end
  end
end
