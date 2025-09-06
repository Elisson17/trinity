class WhatsappVerificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_verified

  def show
  end

  def create
    code = params[:verification_code]

    if current_user.verify_whatsapp_code(code)
      SendWhatsappWelcomeJob.perform_later(current_user.phone_number, current_user.name)
      flash[:notice] = "Conta verificada com sucesso! Bem-vindo(a) à Trinity! 🎉"
      redirect_to v1_root_path
    else
      flash[:alert] = "Código inválido ou expirado. Tente novamente."
      render :show, status: :unprocessable_content
    end
  end

  def resend
    if current_user.generate_verification_code!
      flash[:notice] = "Novo código enviado para seu WhatsApp!"
    else
      flash[:alert] = "Erro ao enviar código. Tente novamente."
    end

    redirect_to whatsapp_verification_path
  end

  private

  def redirect_if_verified
    redirect_to v1_root_path if current_user.verified?
  end
end
