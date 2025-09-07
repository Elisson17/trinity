class V1::CartController < V1::BaseController
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(product: { images_attachments: :blob })
  end

  def add_item
    @product = Product.find(params[:product_id])
    quantity = params[:quantity]&.to_i || 1

    result = @cart.add_product(@product, quantity)
    Rails.logger.info "Add product result: #{result}, Product active: #{@product.active?}"

    if @product.active? && result
      response_data = {
        success: true,
        message: "#{@product.name} adicionado ao carrinho!",
        cart_items_count: @cart.total_items,
        cart_total: @cart.formatted_total_price
      }
      Rails.logger.info "Sending success response: #{response_data}"
      render json: response_data
    else
      error_response = {
        success: false,
        message: "Erro ao adicionar produto ao carrinho",
        errors: @cart.errors.full_messages
      }
      Rails.logger.info "Sending error response: #{error_response}"
      render json: error_response, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      message: "Produto não encontrado"
    }, status: :not_found
  end

  def update_item
    @product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    if @cart.update_item_quantity(@product, quantity)
      @cart.reload

      render json: {
        success: true,
        message: "Quantidade atualizada!",
        cart_items_count: @cart.total_items,
        cart_total: @cart.formatted_total_price,
        item_subtotal: @cart.cart_items.find_by(product: @product)&.formatted_subtotal
      }
    else
      render json: {
        success: false,
        message: "Erro ao atualizar quantidade"
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      message: "Produto não encontrado"
    }, status: :not_found
  end

  def remove_item
    @product = Product.find(params[:product_id])

    if @cart.remove_product(@product)
      @cart.reload

      render json: {
        success: true,
        message: "#{@product.name} removido do carrinho",
        cart_items_count: @cart.total_items,
        cart_total: @cart.formatted_total_price
      }
    else
      render json: {
        success: false,
        message: "Erro ao remover produto"
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      message: "Produto não encontrado"
    }, status: :not_found
  end

  def clear
    @cart.clear!

    render json: {
      success: true,
      message: "Carrinho esvaziado",
      cart_items_count: 0,
      cart_total: "R$ 0,00"
    }
  end

  private

  def set_cart
    @cart = current_cart
  end
end
