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
    @addresses = current_user.addresses.ordered
  end

  def update_profile
    @user = current_user

    if @user.update(user_params)
      redirect_to v1_user_profile_path, notice: "Perfil atualizado com sucesso!"
    else
      render :profile, status: :unprocessable_content
    end
  end

def create_address
  @address = current_user.addresses.build(address_params)

  if @address.save
    redirect_to v1_user_addresses_path, notice: "Endereço adicionado com sucesso!"
  else
    @addresses = current_user.addresses
    flash.now[:alert] = @address.errors.full_messages.join(", ")
    render :addresses, status: :unprocessable_content
  end
end

def update_address
  @address = current_user.addresses.find(params[:id])

  if @address.update(address_params)
    redirect_to v1_user_addresses_path, notice: "Endereço atualizado com sucesso!"
  else
    @addresses = current_user.addresses
    flash.now[:alert] = @address.errors.full_messages.join(", ")
    render :addresses, status: :unprocessable_content
  end
end


def destroy_address
  @address = current_user.addresses.find(params[:id])

  if current_user.addresses.count == 1
    redirect_to v1_user_addresses_path, alert: "Não é possível excluir o único endereço cadastrado."
    return
  end

  if @address.is_default? && current_user.addresses.count > 1
    other_address = current_user.addresses.where.not(id: @address.id).first
    other_address.update(is_default: true) if other_address
  end

  if @address.destroy
    redirect_to v1_user_addresses_path, notice: "Endereço removido com sucesso!"
  else
    redirect_to v1_user_addresses_path, alert: "Não foi possível remover o endereço."
  end
end


  private

  def set_current_section
    @current_section = action_name
  end

  def user_params
    params.require(:user).permit(:email, :name, :phone_number)
  end

  def address_params
    params.require(:address).permit(:nickname, :cep, :street, :number, :complement, :neighborhood, :city, :state, :is_default)
  end
end
