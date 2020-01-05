# frozen_string_literal: true

class EvaluationCriteriumDecorator < ApplicationDecorator
  delegate_all

  def description_html
    description = object.description
    return description.body.to_rendered_html_with_layout if description.persisted?

    'No additional description provided yet.'
  end
end
