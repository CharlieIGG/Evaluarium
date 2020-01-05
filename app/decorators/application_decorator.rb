# frozen_string_literal: true

#
# Base Decorator for All other decorators.
#
class ApplicationDecorator < Draper::Decorator
  include ActionView::Helpers::TranslationHelper
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  def unknown_string
    t('Unknown')
  end

  def new_edit_title
    action = object.persisted? ? t('controllers.actions.edit') : t('controllers.actions.new')
    "#{action.titleize} #{object.model_name.human}"
  end
end
