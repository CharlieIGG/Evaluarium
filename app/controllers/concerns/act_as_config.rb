# frozen_string_literal: true

module ActAsConfig
  extend ActiveSupport::Concern
  included do
    before_action :is_config_section, except: %i[create update destroy]
  end

  def is_config_section
    @config_section = true
  end
end
