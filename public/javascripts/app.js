/*
	By Oto Brglez - <oto.brglez@opalab.com>
*/

$(function(){
	$('#pims_index .pims').infinitescroll({
		nextSelector: "div#pims_paginate a.next",
		navSelector: "div#pims_paginate",
		itemSelector : ".pims .pim"       
	});
});