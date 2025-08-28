class V1::HomeController < V1::BaseController
  def index
    @featured_products = Product.active.featured.limit(10)
    @new_products = Product.active.order(created_at: :desc).limit(10)

    render Views::V1::Home::Index.new(
      current_user: current_user,
      featured_products: @featured_products,
      new_products: @new_products
    )
  end
end
