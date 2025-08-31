class EvolutionWhatsappService
  BASE_URL = ENV.fetch("EVOLUTION_API_URL", "http://evo-oo8cgs8oskgs40wo8ccg88cs.31.220.95.69.sslip.io")
  NAME_INSTANCE = "mistya"

  def self.send_verification_code(phone_number:, whatsapp_code:, name:)
    clean_phone = format_phone_number(phone_number)
    message = build_verification_message(name, whatsapp_code)

    response = send_message(clean_phone, message)

    if response.success?
      Rails.logger.info "Código WhatsApp enviado para #{clean_phone}"
      true
    else
      Rails.logger.error "Erro ao enviar WhatsApp: #{response.body}"
      false
    end
  rescue => e
    Rails.logger.error "Erro no WhatsappService: #{e.message}"
    false
  end

  def self.send_welcome_message(phone_number:, name:)
    clean_phone = format_phone_number(phone_number)
    message = build_welcome_message(name)

    response = send_message(clean_phone, message)

    response.success?
  rescue => e
    Rails.logger.error "Erro ao enviar mensagem de boas-vindas: #{e.message}"
    false
  end

  private

  def self.format_phone_number(phone)
    # O número já vem limpo do banco (apenas dígitos)
    clean = phone.gsub(/\D/, "")

    # Adiciona código do Brasil se necessário
    clean = "55#{clean}" unless clean.start_with?("55")

    clean
  end

  def self.send_message(phone_number, message)
    HTTParty.post("#{BASE_URL}/message/sendText/#{NAME_INSTANCE}", {
      headers: {
        "Content-Type" => "application/json",
        "apikey" => ENV.fetch("EVOLUTION_API_KEY", "jTzJ4b7cCz8d75OB026ML7yIY5KdzLCN")
      },
      body: {
        number: phone_number,
        text: message
      }.to_json
    })
  end

  def self.build_verification_message(name, code)
    <<~MSG
      🔐 *Código de Verificação - Trinity*

      Olá, #{name}! 👋

      Seu código de verificação é: *#{code}*

      ⏰ Este código expira em 15 minutos.

      Se você não solicitou este código, ignore esta mensagem.

      Bem-vindo(a) à Trinity! 🎉
    MSG
  end

  def self.build_welcome_message(name)
    <<~MSG
      🎉 *Bem-vindo(a) à Trinity!*

      Olá, #{name}!

      Sua conta foi verificada com sucesso! ✅

      Agora você pode aproveitar todos os nossos produtos e ofertas especiais.

      Obrigado por se juntar a nós! 🛍️
    MSG
  end
end
