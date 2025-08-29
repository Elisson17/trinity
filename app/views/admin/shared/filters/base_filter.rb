class Views::Admin::Shared::Filters::BaseFilter < Views::Base
  def initialize(filters: [], current_params: {}, form_url: nil, reset_url: nil)
    @filters = filters
    @current_params = current_params || {}
    @form_url = form_url || request.path
    @reset_url = reset_url || request.path
  end

  def view_template
    div class: "bg-white p-4 rounded-lg shadow-sm border border-gray-200 mb-6" do
      div class: "flex items-center justify-between mb-4" do
        h3 class: "text-lg font-medium text-gray-900" do
          "Filtros"
        end

        if has_active_filters?
          link_to @reset_url, class: "text-sm text-gray-500 hover:text-gray-700" do
            "Limpar filtros"
          end
        end
      end

      form_with url: @form_url, method: :get, local: true, class: "space-y-4" do |form|
        render_filters(form)
        render_action_buttons
      end
    end
  end

  private

  def render_filters(form)
    if @filters.any?
      div class: "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4" do
        @filters.each do |filter|
          render_filter_field(form, filter)
        end
      end
    end
  end

  def render_filter_field(form, filter)
    div class: "space-y-1" do
      label class: "block text-sm font-medium text-gray-700" do
        filter[:label]
      end

      case filter[:type]
      when :text
        render_text_filter(form, filter)
      when :select
        render_select_filter(form, filter)
      when :date_range
        render_date_range_filter(form, filter)
      when :boolean
        render_boolean_filter(form, filter)
      when :search
        render_search_filter(form, filter)
      else
        render_text_filter(form, filter)
      end
    end
  end

  def render_text_filter(form, filter)
    form.text_field filter[:name],
                    value: @current_params[filter[:name]],
                    placeholder: filter[:placeholder],
                    class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
  end

  def render_search_filter(form, filter)
    div class: "relative" do
      form.text_field filter[:name],
                      value: @current_params[filter[:name]],
                      placeholder: filter[:placeholder] || "Buscar...",
                      class: "mt-1 block w-full pl-10 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"

      div class: "absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none" do
        icon "search", class: "h-4 w-4 text-gray-400"
      end
    end
  end

  def render_select_filter(form, filter)
    options_with_selection = filter[:options].map do |option_text, option_value|
      selected = @current_params[filter[:name]].to_s == option_value.to_s
      [ option_text, option_value, { selected: selected } ]
    end

    form.select filter[:name],
                options_with_selection,
                { prompt: filter[:prompt] || "Selecione..." },
                { class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm" }
  end

  def render_boolean_filter(form, filter)
    options = [
      [ "Todos", "" ],
      [ "Sim", "true" ],
      [ "Não", "false" ]
    ]

    options_with_selection = options.map do |option_text, option_value|
      selected = @current_params[filter[:name]].to_s == option_value.to_s
      [ option_text, option_value, { selected: selected } ]
    end

    form.select filter[:name],
                options_with_selection,
                {},
                { class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm" }
  end

  def render_date_range_filter(form, filter)
    div class: "grid grid-cols-2 gap-2" do
      div do
        form.date_field "#{filter[:name]}_from",
                        value: @current_params["#{filter[:name]}_from"],
                        placeholder: "De",
                        class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
      end
      div do
        form.date_field "#{filter[:name]}_to",
                        value: @current_params["#{filter[:name]}_to"],
                        placeholder: "Até",
                        class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm"
      end
    end
  end

  def render_action_buttons
    div class: "flex items-center justify-end space-x-3 pt-4 border-t border-gray-200" do
      if has_active_filters?
        link_to @reset_url, class: "px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do
          "Limpar"
        end
      end

      button type: "submit", class: "px-4 py-2 text-sm font-medium text-white bg-indigo-600 border border-transparent rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" do
        icon "funnel", class: "w-4 h-4 mr-2 inline"
        span do
          "Filtrar"
        end
      end
    end
  end

  def has_active_filters?
    return false unless @current_params

    # Converter para hash se for ActionController::Parameters
    params_hash = @current_params.respond_to?(:to_unsafe_h) ? @current_params.to_unsafe_h : @current_params

    params_hash.any? { |key, value|
      value.present? && ![ "page", "per", "controller", "action" ].include?(key.to_s)
    }
  end
end
