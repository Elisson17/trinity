class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :name, presence: { message: "Nome é obrigatório" }
  validates :email, presence: { message: "E-mail é obrigatório" },
                   uniqueness: { message: "Este e-mail já está sendo usado por outra conta" }

  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end
end
