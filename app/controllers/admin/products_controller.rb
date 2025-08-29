class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @product = Product.new
    render Views::Admin::Products::New.new(product: @product)
  end

  def create
    params_hash = product_params
    if params_hash[:price].present? && params_hash[:price].is_a?(String)
      normalized_price = params_hash[:price].to_s
                                           .strip
                                           .gsub(/^R\$\s*/, "")
                                           .gsub(/\s/, "")
                                           .gsub(/\.(?=\d{3,})/, "")
                                           .gsub(",", ".")

      params_hash[:price] = normalized_price.to_f if normalized_price.match?(/^\d+\.?\d*$/)
    end

    @product = Product.new(params_hash)

    if @product.save
      redirect_to admin_products_path, notice: "Produto criado com sucesso!"
    else
      render Views::Admin::Products::New.new(product: @product), status: :unprocessable_entity
    end
  end

  def edit
    render Views::Admin::Products::Edit.new(product: @product)
  end

  def update
    params_hash = product_params
    p params_hash
    if params_hash[:price].present? && params_hash[:price].is_a?(String)
      normalized_price = params_hash[:price].to_s
                                           .strip
                                           .gsub(/^R\$\s*/, "")
                                           .gsub(/\s/, "")
                                           .gsub(/\.(?=\d{3,})/, "")
                                           .gsub(",", ".")

      params_hash[:price] = normalized_price.to_f if normalized_price.match?(/^\d+\.?\d*$/)
    end

    if @product.update(params_hash)
      redirect_to admin_product_path(@product), notice: "Produto atualizado com sucesso!"
    else
      render Views::Admin::Products::Edit.new(product: @product), status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Produto removido com sucesso!"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :sku, :active, :featured, :material, :care_instructions, images: [])
  end
end
