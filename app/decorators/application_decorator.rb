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
end
