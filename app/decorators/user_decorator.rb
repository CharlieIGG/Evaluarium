# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  delegate_all

  def name
    object.name || unknown_string
  end

  def phone
    object.phone || unknown_string
  end

  def position
    object.position || unknown_string
  end

  def invitation_sent_at
    time = object.invitation_sent_at
    return 'N/A' unless time

    l(time, format: :short)
  end

  def invitation_accepted_at
    time = object.invitation_accepted_at
    return 'N/A' unless time

    l(time, format: :short)
  end

  def invited_by
    inviter = object.invited_by
    return 'N/A' unless inviter

    inviter.name || inviter.email
  end

  def html_attr(attr)
    text_class = object.send(attr) ? 'font-weight-bold' : 'text-muted small'
    "<span class='#{text_class}'>#{send(attr)}</span>".html_safe
  end
end
