class Views::V1::Home::Index < Views::Base
  def initialize(current_user:)
    @current_user = current_user
  end

  def view_template
    div class: "max-w-4xl mx-auto" do
      div class: "bg-white p-8 rounded-lg shadow-md" do
        if @current_user
          render_logged_in_content
        else
          render_guest_content
        end
      end
    end
  end

  private

  def render_logged_in_content
    h1 class: "text-3xl font-bold mb-6 text-center text-gray-800" do
      "Bem-vindo à Trinity Store, #{@current_user.name}! 🎉"
    end

    p class: "text-center text-gray-600 mb-8" do
      "Você está logado como #{@current_user.email}"
    end

    render_cards

    div class: "mt-8 text-center" do
      p class: "text-gray-600" do
        "Explore nossos produtos e aproveite suas compras!"
      end
    end
  end

  def render_guest_content
    h1 class: "text-3xl font-bold mb-6 text-center text-gray-800" do
      "Bem-vindo à Trinity Store! 🎉"
    end

    p class: "text-center text-gray-600 mb-8" do
      "Faça login ou registre-se para ter acesso completo a todas as funcionalidades."
    end

    render_cards
  end

  def render_cards
    div class: "grid md:grid-cols-2 lg:grid-cols-3 gap-6 mt-8" do
      # Card Produtos
      div class: "bg-blue-50 p-6 rounded-lg border border-blue-200" do
        h3 class: "text-xl font-semibold text-blue-800 mb-3" do
          "🛍️ Produtos"
        end
        p class: "text-blue-600 mb-4" do
          "Explore nossa coleção de produtos incríveis"
        end
        Button(variant: :default, size: :sm, class: "w-full") do
          "Ver Produtos"
        end
      end

      # Card Favoritos
      div class: "bg-red-50 p-6 rounded-lg border border-red-200" do
        h3 class: "text-xl font-semibold text-red-800 mb-3" do
          "❤️ Favoritos"
        end
        p class: "text-red-600 mb-4" do
          if @current_user
            "Seus produtos favoritos salvos"
          else
            "Salve seus produtos favoritos"
          end
        end
        Button(variant: :destructive, size: :sm, class: "w-full") do
          "Ver Favoritos"
        end
      end

      # Card Carrinho
      div class: "bg-green-50 p-6 rounded-lg border border-green-200" do
        h3 class: "text-xl font-semibold text-green-800 mb-3" do
          "🛒 Carrinho"
        end
        p class: "text-green-600 mb-4" do
          if @current_user
            "Finalize suas compras"
          else
            "Adicione produtos ao carrinho"
          end
        end
        Button(variant: :default, size: :sm, class: "w-full bg-green-600 hover:bg-green-700 rounded-lg") do
          "Ver Carrinho"
        end
      end
    end
  end
end
