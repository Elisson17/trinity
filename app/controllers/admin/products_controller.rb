class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [ :show, :edit, :update, :destroy, :remove_image ]

  def index
    @products = Product.all

    @products = apply_filters(@products, params)

    @products = @products.order(created_at: :desc).page(params[:page]).per(10)

    render Views::Admin::Products::Index.new(
      products: @products,
      current_params: filter_params
    )
  end

  def show
    render Views::Admin::Products::Show.new(product: @product)
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
      render Views::Admin::Products::New.new(product: @product), status: :unprocessable_content
    end
  end

  def edit
    render Views::Admin::Products::Edit.new(product: @product)
  end

  def update
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

    if @product.update(params_hash)
      redirect_to admin_product_path(@product), notice: "Produto atualizado com sucesso!"
    else
      render Views::Admin::Products::Edit.new(product: @product), status: :unprocessable_content
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Produto removido com sucesso!"
  end

  def remove_image
    image_id = params[:image_id]

    if image_id.present?
      image = @product.images.find_by(id: image_id)
      if image
        image.purge
        render json: {
          success: true,
          message: "Imagem removida com sucesso!",
          image_id: image_id
        }
      else
        render json: {
          success: false,
          message: "Imagem não encontrada!"
        }, status: :not_found
      end
    else
      render json: {
        success: false,
        message: "ID da imagem não fornecido!"
      }, status: :bad_request
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :sku, :active, :featured, :material, :care_instructions, images: [])
  end

  def filter_params
    params.permit(:name, :search, :status, :featured, :price_range, :created_at_from, :created_at_to, :page)
  end

  def apply_filters(scope, params)
    # Filtro específico por nome do produto
    if params[:name].present?
      scope = scope.where("name ILIKE ?", "%#{params[:name]}%")
    end

    # Filtro de busca geral
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      scope = scope.where(
        "name ILIKE ? OR sku ILIKE ? OR description ILIKE ?",
        search_term, search_term, search_term
      )
    end

    # Filtro de status
    if params[:status].present?
      case params[:status]
      when "active"
        scope = scope.where(active: true)
      when "inactive"
        scope = scope.where(active: false)
      end
    end

    # Filtro de produto em destaque
    if params[:featured].present?
      case params[:featured]
      when "true"
        scope = scope.where(featured: true)
      when "false"
        scope = scope.where(featured: false)
      end
    end

    # Filtro de faixa de preço
    if params[:price_range].present?
      case params[:price_range]
      when "0-50"
        scope = scope.where(price: 0..50)
      when "51-100"
        scope = scope.where(price: 51..100)
      when "101-500"
        scope = scope.where(price: 101..500)
      when "500+"
        scope = scope.where("price > ?", 500)
      end
    end

    # Filtro de data de criação
    if params[:created_at_from].present?
      scope = scope.where("created_at >= ?", Date.parse(params[:created_at_from]))
    end

    if params[:created_at_to].present?
      scope = scope.where("created_at <= ?", Date.parse(params[:created_at_to]).end_of_day)
    end

    scope
  end
end
