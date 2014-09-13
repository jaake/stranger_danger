
$(document).ready(function() {
  getLocation();
  setInterval(function(){getLocation()}, 30000);
  setInterval(function(){auto_push()}, 2000);
  audio.play();
  $('#loader').hide();
});

var x = document.getElementById("location");
var audio = new Audio('stranger.mp3');
var log = 0;

//$('#image_photo').on('change', auto_push());

function auto_push() {
    if ($('#image_photo').val() != "") {
        $("#tag").submit();
        $("#photo").hide();
        $("#loader").show();
        log = 0
    } else {
        log = log + 1;
        if (log > 14) {
            $('#loader').hide();
            $('#photo').show();
        } else {
            //console.log();
        }
    }
}

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(pushPosition);
    } else {
        x.innerHTML = "Geolocation is not supported by this browser.";
    }
}

function pushPosition(position) {
    $('#image_latitude').val(position.coords.latitude);
    $('#image_longitude').val(position.coords.longitude);
    $.ajax('location.js', {
      format: 'js',
      data: {latitude: position.coords.latitude, longitude: position.coords.longitude}
    })
}



