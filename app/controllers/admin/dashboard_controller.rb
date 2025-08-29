class Admin::DashboardController < Admin::BaseController
  def index
    @total_products = Product.count
    @active_products = Product.active.count
    @featured_products = Product.featured.count
    @recent_products = Product.order(created_at: :desc).limit(5)
  end
end
