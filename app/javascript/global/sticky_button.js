$(document).on('turbolinks:load', function () {
  var wrap = $(window);
  var button = $(".sticky-button");
  if (button.length == 0) return;

  var buttonTop = button.offset().top;
  var stick = function (e) {
    var scrollTop = wrap.scrollTop();
    if (scrollTop >= buttonTop) {
      button.addClass("sticky");
    } else {
      button.removeClass("sticky");
    }
  };

  wrap.on("scroll", stick);
});