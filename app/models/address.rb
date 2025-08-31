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
    if is_default_changed? && is_default?
      user.addresses.where.not(id: id).update_all(is_default: false)
    end

    # Se é o primeiro endereço do usuário, torna-o padrão automaticamente
    if user.addresses.count == 0
      self.is_default = true
    end
  end

  def clean_cep
    return if cep.blank?
    self.cep = cep.gsub(/\D/, "")
  end
end
