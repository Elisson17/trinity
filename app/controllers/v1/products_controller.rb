class V1::ProductsController < V1::BaseController
  before_action :set_product, only: [ :show ]

  def index
    @products = Product.active.with_attached_images

    @products = @products.search_by_name(params[:search]) if params[:search].present?
    @products = @products.featured if params[:featured] == "true"
    @products = @products.by_price_range(params[:min_price], params[:max_price]) if params[:min_price].present? && params[:max_price].present?

    @products = @products.order(:name).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end

  def show
    @related_products = Product.active.where.not(id: @product.id).limit(4)
  end

  private

  def set_product
    @product = Product.active.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to v1_products_path, alert: "Produto não encontrado."
  end
end
