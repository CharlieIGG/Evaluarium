$(document).on('turbolinks:load', function() {
    var wrap = $(window);
    var nav = $(".sticky-button");
    if (nav.length == 0) return;

    var navTop = nav.offset().top;
    var stick = function(e) {
        var scrollTop = wrap.scrollTop();
        if (scrollTop >= navTop) {
            nav.addClass("sticky");
        } else {
            nav.removeClass("sticky");
        }
    };

    wrap.on("scroll", stick);
});