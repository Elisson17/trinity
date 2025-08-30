document.addEventListener("DOMContentLoaded", function () {
  const modal = document.getElementById("address-modal");
  const openModalButtons = document.querySelectorAll(
    '[data-action="open-address-modal"]'
  );
  const closeModalButtons = document.querySelectorAll(
    '[data-action="close-address-modal"]'
  );

  openModalButtons.forEach((button) => {
    button.addEventListener("click", function () {
      if (modal) {
        modal.classList.remove("hidden");
        document.body.style.overflow = "hidden";
      }
    });
  });

  closeModalButtons.forEach((button) => {
    button.addEventListener("click", function () {
      if (modal) {
        modal.classList.add("hidden");
        document.body.style.overflow = "auto";
      }
    });
  });

  if (modal) {
    modal.addEventListener("click", function (e) {
      if (e.target === modal) {
        modal.classList.add("hidden");
        document.body.style.overflow = "auto";
      }
    });
  }

  const phoneInput = document.querySelector('input[name="user[phone_number]"]');
  if (phoneInput) {
    phoneInput.addEventListener("input", function (e) {
      let value = e.target.value.replace(/\D/g, "");
      if (value.length >= 11) {
        value = value.replace(/(\d{2})(\d{5})(\d{4})/, "($1) $2-$3");
      } else if (value.length >= 6) {
        value = value.replace(/(\d{2})(\d{4})(\d{0,4})/, "($1) $2-$3");
      } else if (value.length >= 2) {
        value = value.replace(/(\d{2})(\d{0,5})/, "($1) $2");
      }
      e.target.value = value;
    });
  }

  const cepInput = document.querySelector('input[placeholder="00000-000"]');
  if (cepInput) {
    cepInput.addEventListener("input", function (e) {
      let value = e.target.value.replace(/\D/g, "");
      if (value.length >= 5) {
        value = value.replace(/(\d{5})(\d{0,3})/, "$1-$2");
      }
      e.target.value = value;

      if (value.replace(/\D/g, "").length === 8) {
        console.log("CEP complete:", value);
      }
    });
  }
});
