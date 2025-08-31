class V1::User::Settings::AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [ :show, :edit, :update, :destroy, :set_default ]

  def index
    @addresses = current_user.addresses.ordered
    @address = Address.new
  end

  def show
    render json: { success: true, address: address_json(@address) }
  end

  def new
    @address = current_user.addresses.build
  end

  def create
    @address = current_user.addresses.build(address_params)

    if @address.save
      render json: {
        success: true,
        message: "Endereço criado com sucesso!",
        address: address_json(@address)
      }
    else
      render json: {
        success: false,
        errors: @address.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      render json: {
        success: true,
        message: "Endereço atualizado com sucesso!",
        address: address_json(@address)
      }
    else
      render json: {
        success: false,
        errors: @address.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    render json: {
      success: true,
      message: "Endereço removido com sucesso!"
    }
  end

  def set_default
    @address.update(is_default: true)
    render json: {
      success: true,
      message: "Endereço definido como padrão!"
    }
  end

  # API para buscar endereço por CEP
  def search_cep
    cep = params[:cep]&.gsub(/\D/, "")

    if cep.blank? || cep.length != 8
      render json: { success: false, message: "CEP inválido" }
      return
    end

    # Aqui você pode integrar com uma API de CEP como ViaCEP
    begin
      address_data = fetch_address_by_cep(cep)
      render json: { success: true, data: address_data }
    rescue => e
      render json: { success: false, message: "Erro ao buscar CEP: #{e.message}" }
    end
  end

  private

  def set_address
    @address = current_user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:nickname, :cep, :street, :number, :complement, :neighborhood, :city, :state, :is_default)
  end

  def address_json(address)
    {
      id: address.id,
      nickname: address.nickname,
      cep: address.formatted_cep,
      street: address.street,
      number: address.number,
      complement: address.complement,
      neighborhood: address.neighborhood,
      city: address.city,
      state: address.state,
      is_default: address.is_default,
      full_address: address.full_address
    }
  end

  def fetch_address_by_cep(cep)
    require "net/http"
    require "json"

    uri = URI("https://viacep.com.br/ws/#{cep}/json/")
    response = Net::HTTP.get_response(uri)

    if response.code == "200"
      data = JSON.parse(response.body)
      if data["erro"]
        raise "CEP não encontrado"
      end

      {
        street: data["logradouro"],
        neighborhood: data["bairro"],
        city: data["localidade"],
        state: data["uf"]
      }
    else
      raise "Erro na consulta de CEP"
    end
  end
end
