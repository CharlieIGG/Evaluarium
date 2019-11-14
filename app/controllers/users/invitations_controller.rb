# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    private

    def invite_resource(&block)
      user = resource_class.invite!(invite_params, current_inviter, &block)
      byebug
    end
  end
end
