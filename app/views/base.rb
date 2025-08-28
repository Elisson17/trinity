# frozen_string_literal: true

class Views::Base < Components::Base
  # The `Views::Base` is an abstract class for all your views.

  # By default, it inherits from `Components::Base`, but you
  # can change that to `Phlex::HTML` if you want to keep views and
  # components independent.

  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::FormWith
  include ActionView::Helpers::CsrfHelper
  include ERB::Util

  def Button(**args, &block)
    render RubyUI::Button.new(**args, &block)
  end

  def Carousel(**args, &block)
    render RubyUI::Carousel.new(**args, &block)
  end

  def CarouselContent(**args, &block)
    render RubyUI::CarouselContent.new(**args, &block)
  end

  def CarouselItem(**args, &block)
    render RubyUI::CarouselItem.new(**args, &block)
  end
end
