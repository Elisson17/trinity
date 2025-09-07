import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["itemsCount", "total"];

  connect() {
    console.log("Cart controller connected!");
  }

  addToCart(event) {
    event.preventDefault();

    const productId = event.currentTarget.dataset.productId;
    const quantity = event.currentTarget.dataset.quantity || 1;

    fetch("/v1/cart/add_item", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
      },
      body: JSON.stringify({
        product_id: productId,
        quantity: parseInt(quantity),
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        console.log("Response data:", data);

        if (data.success) {
          this.updateCartCounter(data.cart_items_count);
          this.showToast(data.message, "success");

          const button = event.currentTarget;
          if (button) {
            const originalText = button.innerHTML;
            button.innerHTML = "✓ Adicionado!";
            button.disabled = true;

            setTimeout(() => {
              button.innerHTML = originalText;
              button.disabled = false;
            }, 2000);
          }
        } else {
          this.showToast(data.message, "error");
        }
      })
      .catch((error) => {
        console.error("Erro:", error);
        this.showToast("Erro ao adicionar produto ao carrinho", "error");
      });
  }

  increaseQuantity(event) {
    const productId = event.currentTarget.dataset.productId;
    const input = document.querySelector(
      `input[data-product-id="${productId}"]`
    );
    const currentValue = parseInt(input.value);

    this.updateQuantity(productId, currentValue + 1);
  }

  decreaseQuantity(event) {
    const productId = event.currentTarget.dataset.productId;
    const input = document.querySelector(
      `input[data-product-id="${productId}"]`
    );
    const currentValue = parseInt(input.value);

    if (currentValue > 1) {
      this.updateQuantity(productId, currentValue - 1);
    }
  }

  updateQuantity(productId, quantity) {
    if (quantity <= 0) {
      this.removeItem({ currentTarget: { dataset: { productId } } });
      return;
    }

    fetch("/v1/cart/update_item", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
      },
      body: JSON.stringify({
        product_id: productId,
        quantity: quantity,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          const input = document.querySelector(
            `input[data-product-id="${productId}"]`
          );
          input.value = quantity;

          const subtotalElement = document.querySelector(
            `[data-cart-item-id="${productId}"] [data-cart-subtotal]`
          );
          if (subtotalElement && data.item_subtotal) {
            subtotalElement.textContent = data.item_subtotal;
          }

          this.updateCartCounter(data.cart_items_count);
          this.updateCartTotal(data.cart_total);

          this.showToast(data.message, "success");
        } else {
          this.showToast(data.message, "error");
        }
      })
      .catch((error) => {
        console.error("Erro:", error);
        this.showToast("Erro ao atualizar quantidade", "error");
      });
  }

  removeItem(event) {
    const productId = event.currentTarget.dataset.productId;

    if (!confirm("Remover este item do carrinho?")) {
      return;
    }

    fetch("/v1/cart/remove_item", {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
      },
      body: JSON.stringify({
        product_id: productId,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          const itemElement = document.querySelector(
            `[data-cart-item-id="${productId}"]`
          );
          if (itemElement) {
            itemElement.remove();
          }

          this.updateCartCounter(data.cart_items_count);
          this.updateCartTotal(data.cart_total);

          this.showToast(data.message, "success");

          if (data.cart_items_count === 0) {
            setTimeout(() => {
              window.location.reload();
            }, 1500);
          }
        } else {
          this.showToast(data.message, "error");
        }
      })
      .catch((error) => {
        console.error("Erro:", error);
        this.showToast("Erro ao remover item", "error");
      });
  }

  clearCart(event) {
    console.log("clearCart method called");

    if (!confirm("Tem certeza que deseja esvaziar todo o carrinho?")) {
      return false;
    }

    console.log("Sending clear cart request...");

    fetch("/v1/cart/clear", {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          this.updateCartCounter(0);

          this.showToast(data.message, "success");

          this.showEmptyCartState();
        } else {
          this.showToast(data.message, "error");
        }
      })
      .catch((error) => {
        console.error("Erro:", error);
        this.showToast("Erro ao limpar carrinho", "error");
      });
  }

  showEmptyCartState() {
    const cartContainer = document.querySelector(
      ".container.mx-auto.px-4.py-8"
    );
    if (cartContainer) {
      cartContainer.innerHTML = `
        <div class="flex items-center justify-between mb-8">
          <h1 class="text-3xl font-bold text-gray-900">Carrinho de Compras</h1>
        </div>
        
        <div class="text-center py-16">
          <svg class="mx-auto h-16 w-16 text-gray-400 mb-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4m-2.4 0L1 1M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17M17 13v6a2 2 0 01-2 2H9a2 2 0 01-2-2v-6"></path>
          </svg>
          <h3 class="text-xl font-medium text-gray-900 mb-2">Seu carrinho está vazio</h3>
          <p class="text-gray-500 mb-8">Adicione produtos incríveis ao seu carrinho para começar suas compras!</p>
          <a href="/v1/products" class="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 transition-colors">
            Explorar Produtos
          </a>
        </div>
      `;
    }
  }

  updateCartCounter(count) {
    const headerCounter = document.querySelector(".cart-items-count");
    if (headerCounter) {
      headerCounter.textContent = count;
      headerCounter.style.display = count > 0 ? "flex" : "none";
    }

    const cartCounter = document.querySelector("[data-cart-items-count]");
    if (cartCounter) {
      cartCounter.textContent = count;
    }
  }

  updateCartTotal(total) {
    const totalElements = document.querySelectorAll("[data-cart-total]");
    totalElements.forEach((element) => {
      element.textContent = total;
    });
  }

  showToast(message, type = "success") {
    const toast = document.getElementById("cart-toast");
    const messageElement = document.getElementById("toast-message");

    if (!toast || !messageElement) return;

    messageElement.textContent = message;

    const toastContent = toast.querySelector("div");
    if (type === "success") {
      toastContent.className =
        "bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg";
    } else {
      toastContent.className =
        "bg-red-500 text-white px-6 py-3 rounded-lg shadow-lg";
    }

    toast.classList.remove("hidden");

    setTimeout(() => {
      toast.classList.add("hidden");
    }, 3000);
  }
}
