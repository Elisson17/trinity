class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  layout "admin"

  private

  def ensure_admin
    redirect_to v1_root_path, alert: "Acesso negado." unless current_user&.admin?
  end
end
