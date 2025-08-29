class Views::Admin::Shared::Tables::ProductsTable < Views::Admin::Shared::Tables::BaseTable
  def initialize(products:, pagination: nil)
    columns = [
      {
        label: "Produto",
        render: ->(product) { render_product_info(product) },
        class: "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
      },
      {
        label: "Preço",
        render: ->(product) { product.formatted_price },
        class: "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
      },
      {
        label: "Status",
        render: ->(product) { render_status_badges(product) },
        class: "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
      },
      {
        label: "Data",
        render: ->(product) { l(product.created_at, format: :short) },
        class: "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
      }
    ]

    actions = [
      ->(product) { render_view_action(product) },
      ->(product) { render_edit_action(product) },
      ->(product) { render_delete_action(product) }
    ]

    empty_state = proc do
      div class: "text-center py-8" do
        div class: "text-gray-400 mb-4" do
          icon "package", class: "w-12 h-12 mx-auto"
        end
        p class: "text-gray-500 text-lg mb-2" do
          "Nenhum produto encontrado"
        end
        p class: "text-gray-400 mb-4" do
          "Comece criando seu primeiro produto"
        end
        link_to new_admin_product_path,
                class: "inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700" do
          icon "plus", class: "w-4 h-4 mr-2"
          "Criar Produto"
        end
      end
    end

    super(items: products, columns: columns, actions: actions, pagination: pagination, empty_state: empty_state)
  end

  private

  def render_product_info(product)
    div class: "flex items-center" do
      div class: "flex-shrink-0 h-10 w-10" do
        if product.has_images?
          image_tag product.thumbnail_image("80x80"), class: "h-10 w-10 rounded-lg object-cover"
        else
          div class: "h-10 w-10 rounded-lg bg-gray-200 flex items-center justify-center" do
            icon "image", class: "w-5 h-5 text-gray-400"
          end
        end
      end
      div class: "ml-4" do
        div class: "text-sm font-medium text-gray-900" do
          product.name
        end
        div class: "text-sm text-gray-500" do
          "SKU: #{product.sku}"
        end
      end
    end
  end

  def render_status_badges(product)
    div class: "space-y-1" do
      if product.active?
        span class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800" do
          "Ativo"
        end
      else
        span class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800" do
          "Inativo"
        end
      end

      if product.featured?
        span class: "ml-2 inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800" do
          "Destaque"
        end
      end
    end
  end

  def render_view_action(product)
    link_to admin_product_path(product),
            class: "text-indigo-600 hover:text-indigo-900 p-1",
            title: "Visualizar produto" do
      icon "eye", class: "w-4 h-4"
    end
  end

  def render_edit_action(product)
    link_to edit_admin_product_path(product),
            class: "text-yellow-600 hover:text-yellow-900 p-1",
            title: "Editar produto" do
      icon "pencil", class: "w-4 h-4"
    end
  end

  def render_delete_action(product)
    dialog_id = "delete-product-#{product.id}"

    AlertDialog(id: dialog_id) do
      AlertDialogTrigger do
        button type: "button",
               class: "text-red-600 hover:text-red-900 p-1",
               title: "Excluir produto",
               data: { dialog_target: dialog_id } do
          icon "trash-2", class: "w-4 h-4"
        end
      end

      AlertDialogContent do
        AlertDialogHeader do
          AlertDialogTitle do
            "Confirmar Exclusão"
          end
          AlertDialogDescription do
            "Tem certeza que deseja excluir o produto \"#{product.name}\"? Esta ação não pode ser desfeita."
          end
        end

        AlertDialogFooter do
          AlertDialogCancel do
            "Cancelar"
          end

          form_with url: admin_product_path(product), method: :delete, local: true, class: "inline", data: { turbo_confirm: "Tem certeza que deseja excluir o produto \"#{product.name}\"?" } do |form|
            AlertDialogAction(type: "submit", class: "bg-red-600 hover:bg-red-700 text-white") do
              "Excluir"
            end
          end
        end
      end
    end
  end
end
