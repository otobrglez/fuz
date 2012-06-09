/*
	By Oto Brglez - <oto.brglez@opalab.com>
*/

var map, markers = null;
var build_gmap = function(){
	var start_loc = new google.maps.LatLng(center_location[0],center_location[1]);
	var mapOptions = {
      zoom: 7,
      center: start_loc,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI: true,
      draggable: false,
      scrollwheel: false
    };

    map = new google.maps.Map(document.getElementById('pims_map'),mapOptions);
    markers = [];

    for(var i in my_locations){
    	markers.push(new google.maps.Marker({
	      position: new google.maps.LatLng(my_locations[i][0],my_locations[i][1]),
	      map: map,
	      draggable: false
	  }));
    };
};

$(function(){

	/* infinitescroll */
	$('#pims_index .pims').infinitescroll({
		nextSelector: "div#pims_paginate a.next",
		navSelector: "div#pims_paginate",
		itemSelector : ".pims .pim"       
	});

	/* Google Maps */
	build_gmap();
});