class Views::V1::Home::Index < Views::Base
  def initialize(current_user:, featured_products:, new_products:)
    @current_user = current_user
    @featured_products = featured_products
    @new_products = new_products
  end

  def view_template
    div class: "min-h-screen bg-gray-50" do
      div class: "container mx-auto px-4 py-8 space-y-12" do
        header_section

        if @featured_products.any?
          section_with_carousel(
            title: "Produtos em Destaque",
            subtitle: "Descubra nossa seleção especial",
            products: @featured_products,
            carousel_id: "featured-carousel"
          )
        end

        if @new_products.any?
          section_with_carousel(
            title: "Produtos Novos",
            subtitle: "Últimos lançamentos da nossa coleção",
            products: @new_products,
            carousel_id: "new-carousel"
          )
        end
      end
    end
  end

  private

  def header_section
    div class: "text-center mb-12" do
      h1 class: "text-4xl font-bold text-gray-800 mb-4" do
        "Bem-vinda à Trinity"
      end
      p class: "text-lg text-gray-600 max-w-2xl mx-auto" do
        "Descubra nossa coleção exclusiva de roupas femininas. Peças únicas para mulheres que valorizam estilo e qualidade."
      end
    end
  end

  def section_with_carousel(title:, subtitle: nil, products:, carousel_id:)
    div class: "bg-white p-8 rounded-lg shadow-md" do
      div class: "mb-6" do
        h2 class: "text-3xl font-bold text-gray-800 mb-2" do
          title
        end
        if subtitle
          p class: "text-gray-600" do
            subtitle
          end
        end
      end

      Carousel(data_carousel_id: carousel_id, class: "w-full max-w-full") do
        CarouselContent(class: "-ml-4") do
          products.each do |product|
            CarouselItem(class: "pl-4 md:basis-1/2 lg:basis-1/3 xl:basis-1/4") do
              product_card(product)
            end
          end
        end

        CarouselPrevious(class: "left-4")
        CarouselNext(class: "right-4")
      end
    end
  end

  def product_card(product)
    Card(class: "h-full hover:shadow-lg transition-shadow duration-300") do
      a href: v1_product_path(product), class: "block h-full" do
        if product.has_images?
          div class: "aspect-square overflow-hidden rounded-t-lg" do
            img(
              src: url_for(product.thumbnail_image("400x400")),
              alt: product.name,
              class: "w-full h-full object-cover hover:scale-105 transition-transform duration-300"
            )
          end
        else
          div class: "aspect-square bg-gray-200 rounded-t-lg flex items-center justify-center" do
            span class: "text-gray-500 text-sm" do
              "Sem imagem"
            end
          end
        end

        CardContent(class: "p-4 flex-1 flex flex-col") do
          CardTitle(class: "text-lg font-semibold text-gray-800 mb-2 h-12 overflow-hidden") do
            product.name
          end

          CardDescription(class: "text-gray-600 mb-3 h-16 overflow-hidden text-sm flex-1") do
            product.description.truncate(100)
          end

          div class: "mt-auto space-y-3" do
            p class: "text-xl font-bold text-green-600" do
              product.formatted_price
            end

            button class: "w-full px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 transition-colors",
                   data_controller: "cart",
                   data_action: "click->cart#addToCart",
                   data_product_id: product.id,
                   data_quantity: "1",
                   onclick: safe("event.stopPropagation(); event.preventDefault();") do
              "🛒 Adicionar ao Carrinho"
            end
          end
        end
      end
    end
  end
end
