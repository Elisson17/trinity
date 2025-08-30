import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["removeButton"];
  static values = { productId: Number };

  connect() {}

  async removeImage(event) {
    event.preventDefault();
    const button = event.currentTarget;
    const imageId = button.dataset.imageId;
    const productId = button.dataset.productId;
    const imageContainer = button.closest(".relative.group");


    button.disabled = true;
    button.innerHTML = "...";

    try {
      const response = await fetch(
        `/admin/products/${productId}/remove_image`,
        {
          method: "DELETE",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": this.getCSRFToken(),
            Accept: "application/json",
          },
          body: JSON.stringify({
            image_id: imageId,
          }),
        }
      );

      const data = await response.json();

      if (data.success) {

        imageContainer.style.transition =
          "opacity 0.3s ease-out, transform 0.3s ease-out";
        imageContainer.style.opacity = "0";
        imageContainer.style.transform = "scale(0.95)";

        setTimeout(() => {
          imageContainer.remove();

          const imagesGrid = this.element.querySelector(".grid");
          if (imagesGrid && imagesGrid.children.length === 0) {
            this.element.style.display = "none";
          }
        }, 300);

        this.showNotification(data.message, "success");
      } else {
        console.error("Erro ao remover imagem:", data.message);
        this.showNotification(data.message, "error");

        button.disabled = false;
        button.innerHTML = "✕";
      }
    } catch (error) {
      this.showNotification(
        "Erro ao remover a imagem. Tente novamente.",
        "error"
      );

      button.disabled = false;
      button.innerHTML = "✕";
    }
  }

  getCSRFToken() {
    const metaTag = document.querySelector('meta[name="csrf-token"]');
    return metaTag ? metaTag.getAttribute("content") : "";
  }

  showNotification(message, type) {
    const notification = document.createElement("div");
    notification.className = `fixed top-4 right-4 px-4 py-2 rounded-md text-white z-50 ${
      type === "success" ? "bg-green-500" : "bg-red-500"
    }`;
    notification.textContent = message;

    document.body.appendChild(notification);

    setTimeout(() => {
      notification.remove();
    }, 3000);
  }
}
