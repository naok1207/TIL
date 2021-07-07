$(function() {
  $('body').on('keyup', '#tag_input', function(e) {
      console.log('aaa');
      if(e.keyCode == 188 || e.keyCode == 13) {
        renderText();
      } else if (e.keyCode == 8 && $(this).val() == '') {
        focusBeforeText();
      }
  })
  $('body').on('blur', '#tag_input', function(e) {
      renderText();
    }
  )

  function renderText() {
    var input = $('#input');
    var addText = input.val();
    input.val('');
    if (addText[addText.length - 1] == ',') {
      addText = addText.slice(0, -1)
    }
    if (addText.length) {
      $('#texts').append(`<div>${addText.trim()}</div>`);
    }
  }

  function focusBeforeText() {
    var textsElements = $('#texts').children();
    if (textsElements.length) {
      var scopeElement = $(textsElements[textsElements.length - 1]);
      $('#input').val(scopeElement.text());
      scopeElement.remove();
    }
  }

  $('#submit').on('click', function() {
    var str = [];
    $('#texts').children().each(function() {
      str.push($(this).text());
    })
    $('#submit-text').text(str.join(','));
  })
})
