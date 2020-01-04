import "select2";
import $ from "jquery";

$(document).on("turbolinks:load", () => {
  const currentPath = window.location.href;
  const links = document.getElementsByClassName("nav-link");

  [...links].forEach(link => {
    if (link.href === "#") return;

    if (currentPath.includes(link.href)) {
      link.classList.add("active");
    }
  });
});