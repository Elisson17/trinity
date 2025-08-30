class Views::Admin::Products::Edit < Views::Base
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
          BreadcrumbLink(href: admin_product_path(@product)) { @product.name }
        end
        BreadcrumbSeparator()
        BreadcrumbItem do
          BreadcrumbPage { "Editar" }
        end
      end
    end
  end

  def page_header
    div do
      h1 class: "text-2xl font-bold text-gray-900" do
        "Editar Produto"
      end
      p class: "mt-1 text-sm text-gray-600" do
        "Modifique as informações do produto #{@product.name}"
      end
    end
  end

  def product_form
    div class: "bg-white shadow sm:rounded-lg" do
      div class: "px-4 py-5 sm:p-6" do
        form_with model: [ :admin, @product ], local: true, multipart: true, class: "space-y-6" do |form|
          error_messages if @product.errors.any?

          Form do
            basic_info_section(form)
            description_section(form)
            pricing_and_material_section(form)
            care_instructions_section(form)
            product_status_section(form)
            images_section(form)
            current_images_section if @product.images.attached?
            form_actions(form)
          end
        end
      end
    end
  end

  def error_messages
    div class: "bg-red-50 border border-red-200 rounded-md p-4" do
      div class: "flex" do
        div class: "flex-shrink-0" do
          i class: "h-5 w-5 text-red-400" do
            "⚠️"
          end
        end
        div class: "ml-3" do
          h3 class: "text-sm font-medium text-red-800" do
            "Erro ao atualizar produto:"
          end
          div class: "mt-2 text-sm text-red-700" do
            ul class: "list-disc pl-5 space-y-1" do
              @product.errors.full_messages.each do |message|
                li { message }
              end
            end
          end
        end
      end
    end
  end

  def basic_info_section(form)
    div class: "grid grid-cols-1 gap-6 sm:grid-cols-2" do
      FormField do
        FormFieldLabel(for: "product_name") { "Nome" }
        Input(
          type: "text",
          name: "product[name]",
          id: "product_name",
          value: @product.name,
          placeholder: "Nome do produto",
          class: "mt-1"
        )
        FormFieldError do
          @product.errors[:name].first if @product.errors[:name].any?
        end
      end

      FormField do
        FormFieldLabel(for: "product_sku") { "SKU (Gerado Automaticamente)" }
        Input(
          type: "text",
          id: "product_sku_display",
          value: @product.sku,
          disabled: true,
          class: "mt-1 bg-gray-100"
        )
        FormFieldHint do
          "O SKU é gerado automaticamente baseado no nome do produto"
        end
      end
    end
  end

  def description_section(form)
    FormField do
      FormFieldLabel(for: "product_description") { "Descrição" }
      textarea(
        name: "product[description]",
        id: "product_description",
        rows: "4",
        placeholder: "Descrição detalhada do produto",
        class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
      ) { @product.description }
      FormFieldError do
        @product.errors[:description].first if @product.errors[:description].any?
      end
    end
  end

  def pricing_and_material_section(form)
    div class: "grid grid-cols-1 gap-6 sm:grid-cols-2" do
      FormField do
        FormFieldLabel(for: "product_price") { "Preço" }
        div class: "grid w-full max-w-sm items-center gap-1.5" do
          MaskedInput(
            name: "product[price]",
            id: "product_price",
            value: @product.price ? @product.formatted_price : "",
            placeholder: "R$ 0,00",
            data: { maska: "R$ ###,##", tokens: "###,##" }
          )
        end
        FormFieldError do
          @product.errors[:price].first if @product.errors[:price].any?
        end
      end

      FormField do
        FormFieldLabel(for: "product_material") { "Material" }
        Input(
          type: "text",
          name: "product[material]",
          id: "product_material",
          value: @product.material,
          placeholder: "Material do produto",
          class: "mt-1"
        )
        FormFieldError do
          @product.errors[:material].first if @product.errors[:material].any?
        end
      end
    end
  end

  def care_instructions_section(form)
    FormField do
      FormFieldLabel(for: "product_care_instructions") { "Instruções de Cuidado" }
      textarea(
        name: "product[care_instructions]",
        id: "product_care_instructions",
        rows: "3",
        placeholder: "Como cuidar do produto",
        class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
      ) { @product.care_instructions }
      FormFieldError do
        @product.errors[:care_instructions].first if @product.errors[:care_instructions].any?
      end
    end
  end

  def product_status_section(form)
    div class: "grid grid-cols-1 gap-6 sm:grid-cols-2" do
      FormField do
        input type: "hidden", name: "product[active]", value: "0"
        div class: "flex items-center space-x-3" do
          Checkbox(
            name: "product[active]",
            id: "product_active",
            checked: @product.active?,
            value: "1"
          )
          FormFieldLabel(for: "product_active", class: "text-sm font-medium text-gray-900") do
            "Produto Ativo"
          end
        end
      end

      FormField do
        input type: "hidden", name: "product[featured]", value: "0"
        div class: "flex items-center space-x-3" do
          Checkbox(
            name: "product[featured]",
            id: "product_featured",
            checked: @product.featured?,
            value: "1"
          )
          FormFieldLabel(for: "product_featured", class: "text-sm font-medium text-gray-900") do
            "Produto em Destaque"
          end
        end
      end
    end
  end

  def images_section(form)
    FormField do
      FormFieldLabel(for: "product_images") { "Adicionar Novas Imagens" }
      input(
        type: "file",
        name: "product[images][]",
        id: "product_images",
        multiple: true,
        accept: "image/*",
        class: "mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100"
      )
      FormFieldHint do
        "Selecione uma ou mais imagens do produto (máximo 5MB cada)"
      end
      FormFieldError do
        @product.errors[:images].first if @product.errors[:images].any?
      end
    end
  end

  def current_images_section
    FormField do
      FormFieldLabel { "Imagens Atuais" }
      div class: "grid grid-cols-2 md:grid-cols-4 gap-4 mt-2" do
        @product.images.each_with_index do |image, index|
          div class: "relative group" do
            img(
              src: url_for(image.variant(resize_to_limit: [ 200, 200 ])),
              alt: "Imagem #{index + 1}",
              class: "w-full h-32 object-cover rounded-lg border border-gray-200"
            )
            div class: "absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 rounded-lg transition-all duration-200 flex items-center justify-center" do
              button(
                type: "button",
                class: "opacity-0 group-hover:opacity-100 bg-red-500 text-white rounded-full p-2 hover:bg-red-600 transition-all duration-200",
                title: "Remover imagem"
              ) do
                "✕"
              end
            end
          end
        end
      end
    end
  end

  def form_actions(form)
    div class: "flex justify-end space-x-3" do
      a(
        href: admin_product_path(@product),
        class: "bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
      ) do
        "Cancelar"
      end

      Button(variant: :default, type: "submit") do
        "Atualizar Produto"
      end
    end
  end
end
