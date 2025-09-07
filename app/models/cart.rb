class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :session_id, presence: true, unless: :user_id
  validate :user_or_session_must_be_present

  scope :expired, -> { where("expires_at < ?", Time.current) }
  scope :for_session, ->(session_id) { where(session_id: session_id) }
  scope :for_user, ->(user) { where(user: user) }

  before_create :set_expires_at

  def total_price
    cart_items.sum(&:subtotal)
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def formatted_total_price
    "R$ #{total_price.to_f.round(2).to_s.gsub('.', ',')}"
  end

  def add_product(product, quantity = 1)
    return false unless product&.active?

    existing_item = cart_items.find_by(product: product)

    if existing_item
      existing_item.update(quantity: existing_item.quantity + quantity)
    else
      new_item = cart_items.create(product: product, quantity: quantity)
      new_item.persisted?
    end
  end

  def update_item_quantity(product, quantity)
    item = cart_items.find_by(product: product)
    return false unless item

    if quantity <= 0
      item.destroy
    else
      item.update(quantity: quantity)
    end
  end

  def remove_product(product)
    cart_items.find_by(product: product)&.destroy
  end

  def empty?
    cart_items.empty?
  end

  def clear!
    cart_items.destroy_all
  end

  def merge_with!(other_cart)
    return unless other_cart

    other_cart.cart_items.each do |item|
      add_product(item.product, item.quantity)
    end

    other_cart.destroy
  end

  def expired?
    expires_at && expires_at < Time.current
  end

  def self.cleanup_expired!
    expired.destroy_all
  end

  private

  def user_or_session_must_be_present
    if user_id.blank? && session_id.blank?
      errors.add(:base, "Carrinho deve ter um usuário ou session_id")
    end
  end

  def set_expires_at
    self.expires_at ||= 30.days.from_now
  end
end
