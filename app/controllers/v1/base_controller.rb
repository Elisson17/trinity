class V1::BaseController < ApplicationController
  protected

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def find_or_create_cart
    session_id_string = session.id.to_s

    if user_signed_in?
      cart = current_user.current_cart

      session_cart = Cart.find_by(session_id: session_id_string)
      if session_cart && session_cart != cart
        cart.merge_with!(session_cart)
      end

      cart
    else
      Cart.find_by(session_id: session_id_string) ||
      Cart.create(session_id: session_id_string, expires_at: 30.days.from_now)
    end
  end

  def cart_items_count
    current_cart.total_items
  end
  helper_method :current_cart, :cart_items_count
end
