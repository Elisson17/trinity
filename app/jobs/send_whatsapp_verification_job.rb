class SendWhatsappVerificationJob < ApplicationJob
  queue_as :default

  def perform(phone_number, code, name)
    EvolutionWhatsappService.send_verification_code(
      phone_number: phone_number,
      whatsapp_code: code,
      name: name
    )
  rescue => e
    Rails.logger.error "Erro no job de verificação WhatsApp: #{e.message}"
    retry_job wait: 30.seconds, queue: :default
  end
end
