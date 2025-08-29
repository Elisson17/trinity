class Views::Admin::Shared::Tables::BaseTable < Views::Base
  def initialize(items:, columns:, actions: [], pagination: nil, empty_state: nil)
    @items = items
    @columns = columns
    @actions = actions
    @pagination = pagination
    @empty_state = empty_state || default_empty_state
  end

  def view_template
    div class: "bg-white shadow overflow-hidden sm:rounded-lg" do
      if @items.any?
        render_table
        render_pagination if @pagination
      else
        render_empty_state
      end
    end
  end

  private

  def render_table
    div class: "overflow-x-auto" do
      Table do
        TableHeader do
          TableRow do
            @columns.each do |column|
              TableHead(class: column[:class] || "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider") do
                column[:label]
              end
            end

            if @actions.any?
              TableHead(class: "px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider") do
                "Ações"
              end
            end
          end
        end

        TableBody do
          @items.each do |item|
            TableRow do
              @columns.each do |column|
                TableCell(class: column[:cell_class] || "px-6 py-4 whitespace-nowrap") do
                  if column[:render]
                    instance_exec(item, &column[:render])
                  else
                    item.send(column[:field]) if column[:field]
                  end
                end
              end

              if @actions.any?
                TableCell(class: "px-6 py-4 whitespace-nowrap text-right text-sm font-medium") do
                  div class: "flex justify-end space-x-3" do
                    @actions.each do |action|
                      instance_exec(item, &action)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def render_pagination
    return unless @pagination&.respond_to?(:current_page)

    div class: "px-6 py-3 border-t border-gray-200" do
      div class: "flex items-center justify-between" do
        # Informações sobre os itens
        div class: "text-sm text-gray-700" do
          "Mostrando #{@pagination.offset_value + 1} a #{[ @pagination.offset_value + @pagination.limit_value, @pagination.total_count ].min} de #{@pagination.total_count} itens"
        end

        # Paginação simples
        if @pagination.total_pages > 1
          div class: "flex items-center space-x-2" do
            # Botão anterior
            if @pagination.prev_page
              link_to "?page=#{@pagination.prev_page}",
                      class: "px-3 py-2 text-sm leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700" do
                "Anterior"
              end
            else
              span class: "px-3 py-2 text-sm leading-tight text-gray-300 bg-gray-100 border border-gray-300 rounded-l-lg cursor-not-allowed" do
                "Anterior"
              end
            end

            # Página atual
            span class: "px-3 py-2 text-sm leading-tight text-blue-600 bg-blue-50 border border-gray-300" do
              "#{@pagination.current_page} de #{@pagination.total_pages}"
            end

            # Botão próximo
            if @pagination.next_page
              link_to "?page=#{@pagination.next_page}",
                      class: "px-3 py-2 text-sm leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700" do
                "Próximo"
              end
            else
              span class: "px-3 py-2 text-sm leading-tight text-gray-300 bg-gray-100 border border-gray-300 rounded-r-lg cursor-not-allowed" do
                "Próximo"
              end
            end
          end
        end
      end
    end
  end

  def render_empty_state
    div class: "text-center py-12" do
      @empty_state.call if @empty_state.respond_to?(:call)
    end
  end

  def default_empty_state
    proc do
      div class: "text-center py-8" do
        div class: "text-gray-400 mb-4" do
          icon "inbox", class: "w-12 h-12 mx-auto"
        end
        p class: "text-gray-500 text-lg mb-2" do
          "Nenhum item encontrado"
        end
      end
    end
  end
end
