class Views::Admin::Products::Show < Views::Base
  def initialize(product:)
    @product = product
  end

  def view_template
    div class: "space-y-6" do
      breadcrumb_navigation
      page_header
      product_details
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
          BreadcrumbPage { @product.name }
        end
      end
    end
  end

  def page_header
    div class: "flex justify-between items-start" do
      div do
        h1 class: "text-2xl font-bold text-gray-900" do
          @product.name
        end
        p class: "mt-1 text-sm text-gray-600" do
          "SKU: #{@product.sku}"
        end
      end

      div class: "flex space-x-3" do
        Link(href: edit_admin_product_path(@product)) do
          Button(variant: :outline) do
            "Editar"
          end
        end

        form_with url: admin_product_path(@product), method: :delete,
                  confirm: "Tem certeza que deseja remover este produto?",
                  local: true, class: "inline" do
          Button(variant: :destructive, type: "submit", class: "text-white") do
            "Excluir"
          end
        end
      end
    end
  end

  def product_details
    div class: "bg-white shadow sm:rounded-lg" do
      div class: "px-4 py-5 sm:p-6" do
        div class: "grid grid-cols-1 lg:grid-cols-2 gap-8" do
          product_info
          product_images
        end
      end
    end
  end

  def product_info
    div do
      h3 class: "text-lg font-medium text-gray-900 mb-4" do
        "Informações do Produto"
      end

      dl class: "space-y-4" do
        info_item("Descrição", @product.description)
        info_item("Preço", @product.formatted_price)
        info_item("Material", @product.material)
        info_item("Instruções de Cuidado", @product.care_instructions)
        info_item("Status", @product.active? ? "Ativo" : "Inativo")
        info_item("Em Destaque", @product.featured? ? "Sim" : "Não")
        info_item("Criado em", l(@product.created_at, format: :long))
        info_item("Atualizado em", l(@product.updated_at, format: :long))
      end
    end
  end

  def info_item(label, value)
    div do
      dt class: "text-sm font-medium text-gray-500" do
        label
      end
      dd class: "mt-1 text-sm text-gray-900" do
        value || "Não informado"
      end
    end
  end

  def product_images
    div do
      h3 class: "text-lg font-medium text-gray-900 mb-4" do
        "Imagens (#{@product.images.count})"
      end

      if @product.images.attached?
        div class: "grid grid-cols-2 gap-4" do
          @product.images.each_with_index do |image, index|
            div class: "relative" do
              img(
                src: url_for(image.variant(resize_to_limit: [ 300, 300 ])),
                alt: "Imagem #{index + 1}",
                class: "w-full object-cover rounded-lg border border-gray-200"
              )
              div class: "absolute top-2 right-2 bg-black bg-opacity-50 text-white px-2 py-1 rounded text-xs" do
                "#{index + 1}"
              end
            end
          end
        end
      else
        div class: "border-2 border-dashed border-gray-300 rounded-lg p-8 text-center" do
          div class: "text-gray-400" do
            icon("image", class: "mx-auto h-12 w-12")
          end
          p class: "mt-2 text-sm text-gray-500" do
            "Nenhuma imagem anexada"
          end
          Link(href: edit_admin_product_path(@product)) do
            Button(variant: :outline) do
              "Adicionar Imagens"
            end
          end
        end
      end
    end
  end
end
