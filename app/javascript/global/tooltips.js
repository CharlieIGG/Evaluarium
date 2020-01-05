import $ from "jquery";

$(document).on("turbolinks:load", () => {
    $("[data-toggle=\"tooltip\"]").tooltip({
        container: "body",
        boundary: "window"
    });
});