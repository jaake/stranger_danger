
$(document).ready(function() {
  $(".control").on('click', 'p', pubLocation);
  getLocation();
});

var x = document.getElementById("location");

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(pushPosition);
    } else {
        x.innerHTML = "Geolocation is not supported by this browser.";
    }
}

function pushPosition(position) {
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


