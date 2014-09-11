
$(document).ready(function() {
  getLocation();
  setInterval(function(){getLocation()}, 25000);
  setInterval(function(){auto_push()}, 3000);
  audio.play();
});

var x = document.getElementById("location");

var audio = new Audio('stranger.mp3');


$('#image_photo').on('change', auto_push());

function auto_push() {
    if ($('#image_photo').val() != "") {
        $("#tag").submit();
    }else {

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

function pubLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(publishImage);
    } else {
        x.innerHTML = "Geolocation is not supported by this browser.";
    }
}

function publishImage(position) {
	$.ajax('publish.js', {
      format: 'js',
      data: {latitude: position.coords.latitude, longitude: position.coords.longitude}
    })
}


