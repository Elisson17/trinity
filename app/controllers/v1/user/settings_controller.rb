class V1::User::SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_section
  layout "user_settings"

  def profile
    @user = current_user
  end

  def orders
    @orders = []
  end

  def favorites
    @favorites = []
  end

  def addresses
    @addresses = []
  end

  def update_profile
    @user = current_user

    if @user.update(user_params)
      redirect_to v1_user_profile_path, notice: "Perfil atualizado com sucesso!"
    else
      render :profile, status: :unprocessable_entity
    end
  end

  def create_address
    redirect_to v1_user_addresses_path, notice: "Endereço adicionado com sucesso!"
  end

  def destroy_address
    redirect_to v1_user_addresses_path, notice: "Endereço removido com sucesso!"
  end

  private

  def set_current_section
    @current_section = action_name
  end

  def user_params
    params.require(:user).permit(:name, :phone_number)
  end
end
