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
        div class: "flex-1"

        if @pagination.total_pages > 1
          div class: "flex items-center justify-center space-x-1" do
            render_pagination_buttons
          end
        else
          div class: "flex-1"
        end

        div class: "flex-1 flex justify-end" do
          div class: "text-sm text-gray-700" do
            "Mostrando #{@pagination.offset_value + 1} a #{[ @pagination.offset_value + @pagination.limit_value, @pagination.total_count ].min} de #{@pagination.total_count} itens"
          end
        end
      end
    end
  end

  def render_pagination_buttons
    current_page = @pagination.current_page
    total_pages = @pagination.total_pages

    if current_page > 1
      link_to "?page=1", class: pagination_button_class do
        "Primeiro"
      end
    else
      span class: pagination_disabled_class do
        "Primeiro"
      end
    end

    if @pagination.prev_page
      link_to "?page=#{@pagination.prev_page}", class: pagination_button_class do
        "Anterior"
      end
    else
      span class: pagination_disabled_class do
        "Anterior"
      end
    end

    render_page_numbers

    if @pagination.next_page
      link_to "?page=#{@pagination.next_page}", class: pagination_button_class do
        "Próximo"
      end
    else
      span class: pagination_disabled_class do
        "Próximo"
      end
    end

    if current_page < total_pages
      link_to "?page=#{total_pages}", class: pagination_button_class do
        "Último"
      end
    else
      span class: pagination_disabled_class do
        "Último"
      end
    end
  end

  def render_page_numbers
    current_page = @pagination.current_page
    total_pages = @pagination.total_pages

    if total_pages <= 7
      (1..total_pages).each do |page|
        render_page_link(page)
      end
    else
      if current_page <= 4
        (1..5).each { |page| render_page_link(page) }
        render_ellipsis
        render_page_link(total_pages)
      elsif current_page >= total_pages - 3
        render_page_link(1)
        render_ellipsis
        ((total_pages - 4)..total_pages).each { |page| render_page_link(page) }
      else
        render_page_link(1)
        render_ellipsis
        ((current_page - 1)..(current_page + 1)).each { |page| render_page_link(page) }
        render_ellipsis
        render_page_link(total_pages)
      end
    end
  end

  def render_page_link(page)
    if page == @pagination.current_page
      span class: pagination_current_class do
        page.to_s
      end
    else
      link_to "?page=#{page}", class: pagination_button_class do
        page.to_s
      end
    end
  end

  def render_ellipsis
    span class: "px-3 rounded-md py-2 text-sm leading-tight text-gray-500" do
      "..."
    end
  end

  def pagination_button_class
    "px-3 rounded-md py-2 text-sm leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 transition-colors duration-200"
  end

  def pagination_current_class
    "px-3 rounded-md py-2 text-sm leading-tight text-white bg-blue-600 border border-blue-600"
  end

  def pagination_disabled_class
    "px-3 rounded-md py-2 text-sm leading-tight text-gray-300 bg-gray-100 border border-gray-300 cursor-not-allowed"
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
