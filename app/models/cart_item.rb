class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true,
                      numericality: {
                        greater_than: 0,
                        only_integer: true,
                        message: "deve ser um número inteiro maior que zero"
                      }
  validates :product_id, uniqueness: {
    scope: :cart_id,
    message: "já está no carrinho"
  }

  validate :product_must_be_active
  validate :reasonable_quantity

  before_save :update_cart_expires_at

  def subtotal
    quantity * product.price
  end

  def formatted_subtotal
    "R$ #{subtotal.to_f.round(2).to_s.gsub('.', ',')}"
  end

  def increase_quantity(amount = 1)
    update(quantity: quantity + amount)
  end

  def decrease_quantity(amount = 1)
    new_quantity = quantity - amount
    if new_quantity <= 0
      destroy
    else
      update(quantity: new_quantity)
    end
  end

  def unit_price
    product.price
  end

  def formatted_unit_price
    product.formatted_price
  end

  private

  def product_must_be_active
    if product&.active == false
      errors.add(:product, "não está mais disponível")
    end
  end

  def reasonable_quantity
    if quantity && quantity > 99
      errors.add(:quantity, "não pode ser maior que 99")
    end
  end

  def update_cart_expires_at
    cart.update_column(:expires_at, 30.days.from_now) if cart.session_id.present?
  end
end
