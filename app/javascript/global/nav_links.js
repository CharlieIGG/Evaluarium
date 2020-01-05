import "select2";
import $ from "jquery";
import { developerWarn } from "../utils/loggers";

const currentPath = () => window.location.href;

$(document).on("turbolinks:load", () => {
  const links = document.getElementsByClassName("nav-link");

  [...links].forEach(link => {
    if (link.dataset.pathMatchers) {
      return matchLinkPathMatchers(link);
    }
    matchLinkHref(link);
  });
});

const matchLinkHref = link => {
  if (link.href === "#") return;
  if (!currentPath().includes(link.href)) return;

  makeLinkActive(link);
};

const matchLinkPathMatchers = link => {
  const matchers = JSON.parse(link.dataset.pathMatchers);
  if (!Array.isArray(matchers)) {
    developerWarn("data-path-matchers must be of type Array<String>!");
    return;
  };

  const currentHref = link.href;
  if (matchers.some(testHrefRegex, currentHref)) {
    makeLinkActive(link);
  }
};

const makeLinkActive = link => link.classList.add("active");

// Cannot use arrow function, since it breaks the scope of "this" needed for
// this to work with Array.prototype.some().
const testHrefRegex = function testHrefRegex(regexpString) {
  let regexp = null;
  try {
    regexp = RegExp(regexpString, "g");
  } catch (error) {
    developerWarn(error);
    return false;
  }

  return regexp.test(this);
};