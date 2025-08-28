class V1::HomeController < V1::BaseController
  def index
    render Views::V1::Home::Index.new(current_user: current_user)
  end
end
