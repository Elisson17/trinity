class Product < ApplicationRecord
  has_many_attached :images

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sku, presence: true, uniqueness: true,
            format: { with: /\A[A-Z0-9\-]+\z/, message: "deve conter apenas letras maiúsculas, números e hífens" }

  scope :active, -> { where(active: true) }
  scope :featured, -> { where(featured: true) }
  scope :by_price_range, ->(min, max) { where(price: min..max) }
  scope :search_by_name, ->(term) { where("name ILIKE ?", "%#{term}%") }

  before_validation :generate_sku, if: -> { sku.blank? }
  before_validation :format_name
  before_validation :normalize_price

  def formatted_price
    "R$ #{price.to_f.round(2).to_s.gsub('.', ',')}"
  end

  def available?
    active?
  end

  def slug
    name.parameterize
  end

  def main_image
    images.attached? ? images.first : nil
  end

  def thumbnail_image(size = "300x300")
    return nil unless main_image
    main_image.variant(resize_to_limit: size.split("x").map(&:to_i))
  end

  def has_images?
    images.attached?
  end

  private

  def acceptable_images
    return unless images.attached?

    images.each do |image|
      unless image.blob.content_type.start_with?("image/")
        errors.add(:images, "deve ser uma imagem")
      end

      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "deve ter menos de 5MB")
      end
    end
  end

  def generate_sku
    base = name.present? ? name.upcase.gsub(/[^A-Z0-9]/, "") : "PROD"
    timestamp = Time.current.to_i.to_s[-6..-1]
    self.sku = "#{base[0..3]}#{timestamp}"
  end

  def format_name
    self.name = name.strip.titleize if name.present?
  end

  def normalize_price
    if price.is_a?(String) && price.present?
      # Remove "R$ " e converte vírgula para ponto
      normalized_price = price.to_s
                             .gsub(/^R\$\s*/, "") # Remove R$ do início
                             .gsub(/\s/, "")      # Remove espaços
                             .gsub(/\.(?=\d{3})/, "") # Remove pontos de milhares
                             .gsub(",", ".")      # Converte vírgula decimal para ponto

      self.price = normalized_price.to_f if normalized_price.present?
    end
  end
end
