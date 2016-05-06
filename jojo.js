$(function() {
  SHUFFLE_COUNT = 20

  function start(stands) {
    $('#wrapper').click(function() {
      shuffle(stands, SHUFFLE_COUNT);
    });
  }

  function shuffle(stands, counter) {
    if (counter < 1) { return }

    var stand = _.sample(stands);

    $('h1').text(stand.stand_name);
    $('h2').text(stand.operator_name);

    setTimeout(function() { shuffle(stands, counter - 1)}, 50);
  }

  function fit() {
    $('#wrapper').width($(window).width()).height($(window).height());
  }

  fit();
  $(window).resize(fit);

  $.getJSON('./stands.json', function(data) {
    start(data);
  });
});
