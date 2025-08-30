class Views::Admin::Products::New < Views::Base
  def initialize(product:)
    @product = product
  end

  def view_template
    div class: "space-y-6" do
      breadcrumb_navigation
      page_header
      product_form
    end
  end

  private

  def breadcrumb_navigation
    BreadCrumb do
      BreadcrumbList do
        BreadcrumbItem do
          BreadcrumbLink(href: admin_products_path) { "Produtos" }
        end
        BreadcrumbSeparator()
        BreadcrumbItem do
          BreadcrumbPage { "Novo Produto" }
        end
      end
    end
  end

  def page_header
    div do
      h1 class: "text-2xl font-bold text-gray-900" do
        "Novo Produto"
      end
      p class: "mt-1 text-sm text-gray-600" do
        "Adicione um novo produto ao catálogo"
      end
    end
  end

  def product_form
    render Views::Admin::Products::Form.new(
      product: @product,
      url: admin_products_path,
      method: :post
    )
  end
end
