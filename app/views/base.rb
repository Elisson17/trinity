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

  # Componente de MaskedInput

  def MaskedInput(**args, &block)
    render RubyUI::MaskedInput.new(**args, &block)
  end

  # Componente de BreadCrumb

  def BreadCrumb(**args, &block)
    render RubyUI::Breadcrumb.new(**args, &block)
  end

  def BreadcrumbEllipsis(**args, &block)
    render RubyUI::BreadcrumbEllipsis.new(**args, &block)
  end

  def BreadcrumbItem(**args, &block)
    render RubyUI::BreadcrumbItem.new(**args, &block)
  end

  def BreadcrumbLink(**args, &block)
    render RubyUI::BreadcrumbLink.new(**args, &block)
  end

  def BreadcrumbList(**args, &block)
    render RubyUI::BreadcrumbList.new(**args, &block)
  end

  def BreadcrumbPage(**args, &block)
    render RubyUI::BreadcrumbPage.new(**args, &block)
  end

  def BreadcrumbSeparator(**args, &block)
    render RubyUI::BreadcrumbSeparator.new(**args, &block)
  end

  # Componente de Dialog/Modal

  def Dialog(**args, &block)
    render RubyUI::Dialog.new(**args, &block)
  end

  def DialogContent(**args, &block)
    render RubyUI::DialogContent.new(**args, &block)
  end

  def DialogDescription(**args, &block)
    render RubyUI::DialogDescription.new(**args, &block)
  end

  def DialogFooter(**args, &block)
    render RubyUI::DialogFooter.new(**args, &block)
  end

  def DialogHeader(**args, &block)
    render RubyUI::DialogHeader.new(**args, &block)
  end

  def DialogMiddle(**args, &block)
    render RubyUI::DialogMiddle.new(**args, &block)
  end

  def DialogTitle(**args, &block)
    render RubyUI::DialogTitle.new(**args, &block)
  end

  def DialogTrigger(**args, &block)
    render RubyUI::DialogTrigger.new(**args, &block)
  end

  # Componentes de tabela Table

  def Table(**args, &block)
    render RubyUI::Table.new(**args, &block)
  end

  def TableBody(**args, &block)
    render RubyUI::TableBody.new(**args, &block)
  end

  def TableCaption(**args, &block)
    render RubyUI::TableCaption.new(**args, &block)
  end

  def TableCell(**args, &block)
    render RubyUI::TableCell.new(**args, &block)
  end

  def TableFooter(**args, &block)
    render RubyUI::TableFooter.new(**args, &block)
  end

  def TableHead(**args, &block)
    render RubyUI::TableHead.new(**args, &block)
  end

  def TableHeader(**args, &block)
    render RubyUI::TableHeader.new(**args, &block)
  end

  def TableRow(**args, &block)
    render RubyUI::TableRow.new(**args, &block)
  end

  # Componente de paginação

  def Pagination(**args, &block)
    render RubyUI::Pagination.new(**args, &block)
  end

  def PaginationContent(**args, &block)
    render RubyUI::PaginationContent.new(**args, &block)
  end

  def PaginationEllipsis(**args, &block)
    render RubyUI::PaginationEllipsis.new(**args, &block)
  end

  def PaginationItem(**args, &block)
    render RubyUI::PaginationItem.new(**args, &block)
  end

  # Componente de alert

  def Alert(**args, &block)
    render RubyUI::Alert.new(**args, &block)
  end

  def AlertDescription(**args, &block)
    render RubyUI::AlertDescription.new(**args, &block)
  end

  def AlertTitle(**args, &block)
    render RubyUI::AlertTitle.new(**args, &block)
  end

  # Componente de Dialogo de alerta (Alert Dialog)

  def AlertDialog(**args, &block)
    render RubyUI::AlertDialog.new(**args, &block)
  end

  def AlertDialogAction(**args, &block)
    render RubyUI::AlertDialogAction.new(**args, &block)
  end

  def AlertDialogCancel(**args, &block)
    render RubyUI::AlertDialogCancel.new(**args, &block)
  end

  def AlertDialogContent(**args, &block)
    render RubyUI::AlertDialogContent.new(**args, &block)
  end

  def AlertDialogDescription(**args, &block)
    render RubyUI::AlertDialogDescription.new(**args, &block)
  end

  def AlertDialogFooter(**args, &block)
    render RubyUI::AlertDialogFooter.new(**args, &block)
  end

  def AlertDialogHeader(**args, &block)
    render RubyUI::AlertDialogHeader.new(**args, &block)
  end

  def AlertDialogTitle(**args, &block)
    render RubyUI::AlertDialogTitle.new(**args, &block)
  end

  def AlertDialogTrigger(**args, &block)
    render RubyUI::AlertDialogTrigger.new(**args, &block)
  end
end
