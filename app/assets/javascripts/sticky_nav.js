$(document).on('turbolinks:load', function() {
    var wrap = $(window);
    var header = $(".header--main");
    var nav = $('.navbar--sticky')
    var abort = ((header.length == 0) || (nav.length == 0))
    if (abort) return;

    var headerTop = header.offset().top;
    var stick = function(e) {
        var scrollTop = wrap.scrollTop();
        if (scrollTop >= headerTop) {
            nav.addClass("is-active");
        } else {
            nav.removeClass("is-active");
        }
    };
    wrap.on("scroll", stick);
});