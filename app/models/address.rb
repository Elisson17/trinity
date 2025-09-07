class Address < ApplicationRecord
  belongs_to :user

  validates :nickname, presence: { message: "Nome do endereço é obrigatório" }
  validates :cep, presence: { message: "CEP é obrigatório" },
                  format: { with: /\A\d{5}-?\d{3}\z/, message: "CEP deve ter o formato 00000-000" }
  validates :street, presence: { message: "Rua é obrigatória" }
  validates :number, presence: { message: "Número é obrigatório" }
  validates :neighborhood, presence: { message: "Bairro é obrigatório" }
  validates :city, presence: { message: "Cidade é obrigatória" }
  validates :state, presence: { message: "Estado é obrigatório" }

  validate :ensure_has_one_default_address

  before_save :ensure_only_one_default
  before_save :clean_cep

  scope :default, -> { where(is_default: true) }
  scope :ordered, -> { order(is_default: :desc, created_at: :desc) }

  def formatted_cep
    return cep if cep.blank?
    clean = cep.gsub(/\D/, "")
    return cep if clean.length != 8
    "#{clean[0..4]}-#{clean[5..7]}"
  end

  def full_address
    address_parts = [ street ]
    address_parts << ", #{number}" if number.present?
    address_parts << " - #{complement}" if complement.present?
    address_parts << ", #{neighborhood}"
    address_parts << ", #{city} - #{state}"
    address_parts << ", #{formatted_cep}"
    address_parts.join("")
  end

  private

  def ensure_only_one_default
    if is_default?
      user.addresses.where.not(id: id).update_all(is_default: false)
    end

    existing_addresses_count = user.addresses.where.not(id: id).count
    if existing_addresses_count == 0
      self.is_default = true
    end

    if !marked_for_destruction? && user.addresses.where(is_default: true).where.not(id: id).count == 0 && !is_default?
      self.is_default = true
    end
  end

  def clean_cep
    return if cep.blank?
    self.cep = cep.gsub(/\D/, "")
  end

  def ensure_has_one_default_address
    return if marked_for_destruction?

    if !is_default? && is_default_changed?
      other_defaults = user.addresses.where.not(id: id).where(is_default: true)
      if other_defaults.empty?
        errors.add(:is_default, "Deve existir pelo menos um endereço principal")
      end
    end
  end
end
