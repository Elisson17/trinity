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

  # Componente de botão
  def Button(**args, &block)
    render RubyUI::Button.new(**args, &block)
  end

  # Componentes do carrosel
  def Carousel(**args, &block)
    render RubyUI::Carousel.new(**args, &block)
  end

  def CarouselContent(**args, &block)
    render RubyUI::CarouselContent.new(**args, &block)
  end

  def CarouselItem(**args, &block)
    render RubyUI::CarouselItem.new(**args, &block)
  end

  def CarouselNext(**args, &block)
    render RubyUI::CarouselNext.new(**args, &block)
  end

  def CarouselPrevious(**args, &block)
    render RubyUI::CarouselPrevious.new(**args, &block)
  end

  # Componentes do Card
  def Card(**args, &block)
    render RubyUI::Card.new(**args, &block)
  end

  def CardContent(**args, &block)
    render RubyUI::CardContent.new(**args, &block)
  end

  def CardDescription(**args, &block)
    render RubyUI::CardDescription.new(**args, &block)
  end

  def CardFooter(**args, &block)
    render RubyUI::CardFooter.new(**args, &block)
  end

  def CardHeader(**args, &block)
    render RubyUI::CardHeader.new(**args, &block)
  end

  def CardTitle(**args, &block)
    render RubyUI::CardTitle.new(**args, &block)
  end

  # Componentes do Form

  def Form(**args, &block)
    render RubyUI::Form.new(**args, &block)
  end

  def FormField(**args, &block)
    render RubyUI::FormField.new(**args, &block)
  end

  def FormFieldError(**args, &block)
    render RubyUI::FormFieldError.new(**args, &block)
  end

  def FormFieldHint(**args, &block)
    render RubyUI::FormFieldHint.new(**args, &block)
  end

  def FormFieldLabel(**args, &block)
    render RubyUI::FormFieldLabel.new(**args, &block)
  end

  # Componente de Input

  def Input(**args, &block)
    render RubyUI::Input.new(**args, &block)
  end

  # Componentes de CheckBox

  def Checkbox(**args, &block)
    render RubyUI::Checkbox.new(**args, &block)
  end

  def CheckboxGroup(**args, &block)
    render RubyUI::CheckboxGroup.new(**args, &block)
  end
end
