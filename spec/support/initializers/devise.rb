module RequestSpecHelper
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource))
  end

  def sign_out(resource)
    logout(warden_scope(resource))
  end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end

module RequestSpecMacros
  def signed_in_as(given_variable_or_factory_name)
    before do
      user_to_sign_in = if respond_to? given_variable_or_factory_name
                          send given_variable_or_factory_name
                        else
                          create given_variable_or_factory_name
                        end

      sign_in(user_to_sign_in)
    end
  end
end

RSpec.configure do |config|
  %i[request system].each do |spec_type|
    config.include RequestSpecHelper, type: spec_type
    config.extend  RequestSpecMacros, type: spec_type
  end
end
