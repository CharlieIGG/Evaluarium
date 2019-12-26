# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    private

    def invite_resource(&block)
      authorize resource_class, :create?
      # We will override this method to also assign roles
      resource_class.invite!(invite_params, current_inviter, &block)
    end

    def after_invite_path_for(_resource)
      users_path
    end
  end
end
