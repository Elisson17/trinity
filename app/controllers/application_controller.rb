class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.verified?
      v1_root_path
    else
      whatsapp_verification_path
    end
  end

  def after_sign_up_path_for(resource)
    whatsapp_verification_path
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :phone_number ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :phone_number ])
  end
end
