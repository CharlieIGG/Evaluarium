import "select2";
import $ from "jquery";

$(document).on("turbolinks:load", () => {
  $(".auto-select2").select2();
});