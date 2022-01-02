// For Phoenix.HTML support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * deps/phoenix_html/priv/static/phoenix_html.js

// For Phoenix.Channels support, copy the following scripts
// into your javascript bundle:
// * deps/phoenix/priv/static/phoenix.js

// For Phoenix.LiveView support, copy the following scripts
// into your javascript bundle:
// * deps/phoenix_live_view/priv/static/phoenix_live_view.js


var buttontimer;

function onCopyClick(e) {
  e.preventDefault();

  var self = this;

  this.classList.add("copied");
  this.innerText = "COPIED";
  
  if (buttontimer) { clearTimeout(buttontimer); }

  buttontimer = setTimeout(
    function() {
      self.classList.remove("copied");
      self.innerText = "COPY"
    },
    1500
  );

  var urlInput = document.getElementById("page_url");
  var urlHref = urlInput.href;

  navigator.clipboard.writeText(urlHref);

  // return selection states to normal
  var selection = document.getSelection();
  selection.removeAllRanges();
  this.blur();
}

window.onload = function() {
  var copyButton = document.getElementById("saved-url-copy");
  copyButton.onclick = onCopyClick;
};
