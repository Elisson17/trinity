class SendWhatsappWelcomeJob < ApplicationJob
  queue_as :default

  def perform(phone_number, name)
    EvolutionWhatsappService.send_welcome_message(
      phone_number: phone_number,
      name: name
    )
  rescue => e
    Rails.logger.error "Erro no job de boas-vindas WhatsApp: #{e.message}"
    retry_job wait: 30.seconds, queue: :default
  end
end
