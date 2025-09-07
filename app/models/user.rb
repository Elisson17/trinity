class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy

  validates :name, presence: { message: "Nome é obrigatório" }
  validates :email, presence: { message: "E-mail é obrigatório" },
                   uniqueness: { message: "Este e-mail já está sendo usado por outra conta" }
  validates :phone_number, presence: { message: "Número do WhatsApp é obrigatório" },
                          uniqueness: { message: "Este número já está sendo usado por outra conta" }

  before_save :clean_phone_number
  before_create :generate_whatsapp_verification_code
  after_create :send_whatsapp_verification

  def verified?
    phone_verified_at.present?
  end

  def verify_whatsapp_code(code)
    if whatsapp_code == code && whatsapp_code_expires_at > Time.current
      result = update_columns(
        phone_verified_at: Time.current,
        whatsapp_code: nil,
        whatsapp_code_expires_at: nil
      )
      result
    else
      false
    end
  end

  def generate_verification_code!
    return false if phone_number.blank?

    generate_whatsapp_verification_code
    SendWhatsappVerificationJob.perform_later(phone_number, whatsapp_code, name)

    update_columns(
      whatsapp_code: whatsapp_code,
      whatsapp_code_expires_at: whatsapp_code_expires_at
    )

    true
  rescue => e
    Rails.logger.error "Erro ao gerar código de verificação: #{e.message}"
    false
  end

  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end

  def default_address
    addresses.default.first
  end

  def formatted_phone_number
    return phone_number if phone_number.blank?

    clean = phone_number.gsub(/\D/, "")
    return phone_number if clean.length < 10

    if clean.length == 11
      "#{clean[0..1]} #{clean[2..6]}-#{clean[7..10]}"
    elsif clean.length == 10
      "#{clean[0..1]} #{clean[2..5]}-#{clean[6..9]}"
    else
      phone_number
    end
  end

  private

  def clean_phone_number
    return if phone_number.blank?

    cleaned = phone_number.to_s.strip.gsub(/\D/, "")
    self.phone_number = cleaned unless cleaned.blank?
  end

  def generate_whatsapp_verification_code
    self.whatsapp_code = rand(100000..999999).to_s
    self.whatsapp_code_expires_at = 15.minutes.from_now
  end

  def send_whatsapp_verification
    SendWhatsappVerificationJob.perform_later(phone_number, whatsapp_code, name)
  rescue => e
    Rails.logger.error "Erro ao enviar código WhatsApp: #{e.message}"
  end
end
