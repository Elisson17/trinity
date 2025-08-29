class Views::Admin::Products::Index < Views::Base
  def initialize(products:)
    @products = products
  end

  def view_template
    div class: "space-y-6" do
      page_header
      products_table
    end
  end

  private

  def page_header
    div class: "flex items-center justify-between" do
      h1 class: "text-2xl font-bold text-gray-900" do
        "Produtos"
      end

      link_to new_admin_product_path, class: "inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do
        icon "plus", class: "w-4 h-4 mr-2 flex-shrink-0"
        span class: "whitespace-nowrap" do
          "Novo Produto"
        end
      end
    end
  end

  def products_table
    render Views::Admin::Shared::Tables::ProductsTable.new(
      products: @products,
      pagination: @products.respond_to?(:current_page) ? @products : nil
    )
  end
end
