class Views::Admin::Shared::Filters::ProductsFilter < Views::Admin::Shared::Filters::BaseFilter
  def initialize(current_params: {}, form_url: nil, reset_url: nil)
    filters = [
      {
        type: :text,
        name: :name,
        label: "Nome do produto",
        placeholder: "Digite o nome do produto..."
      },
      {
        type: :search,
        name: :search,
        label: "Busca geral",
        placeholder: "Nome, SKU ou descrição..."
      },
      {
        type: :select,
        name: :status,
        label: "Status",
        options: [
          [ "Ativo", "active" ],
          [ "Inativo", "inactive" ]
        ],
        prompt: "Todos os status"
      }
      # {
      #   type: :boolean,
      #   name: :featured,
      #   label: "Produto em destaque"
      # },
      # {
      #   type: :select,
      #   name: :price_range,
      #   label: "Faixa de preço",
      #   options: [
      #     [ "Até R$ 50", "0-50" ],
      #     [ "R$ 51 - R$ 100", "51-100" ],
      #     [ "R$ 101 - R$ 500", "101-500" ],
      #     [ "Acima de R$ 500", "500+" ]
      #   ],
      #   prompt: "Todas as faixas"
      # },
      # {
      #   type: :date_range,
      #   name: :created_at,
      #   label: "Data de criação"
      # }
    ]

    super(
      filters: filters,
      current_params: current_params,
      form_url: form_url,
      reset_url: reset_url
    )
  end
end
