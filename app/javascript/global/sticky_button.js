import $ from "jquery";

$(document).on("turbolinks:load", () => {
  const wrap = $(window);
  const button = $(".sticky-button");
  if (button.length === 0) return;

  const buttonTop = button.offset().top;
  const stick = () => {
    const scrollTop = wrap.scrollTop();
    if (scrollTop >= buttonTop) {
      button.addClass("sticky");
    } else {
      button.removeClass("sticky");
    }
  };

  wrap.on("scroll", stick);
});