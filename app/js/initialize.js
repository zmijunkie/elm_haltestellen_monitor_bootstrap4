
window.$ = window.jQuery = require('jquery');

window.Popper = require('popper.js');
require('bootstrap');

document.addEventListener('DOMContentLoaded', () => {
  const elmNode = document.getElementById('elm-main')
  Elm.Main.embed(elmNode)
})
