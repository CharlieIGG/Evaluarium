$(document).on("turbolinks:load", function () {
    $('[data-toggle="tooltip"]').tooltip({
        container: 'body',
        boundary: 'window'
    })
})