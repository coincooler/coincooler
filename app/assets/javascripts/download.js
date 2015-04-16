function clearFlashes() {
	$('.alert-success').hide();
	$('.alert-error').hide();
	$('.alert-info').hide();
	flasher = 0;
}
function popFlash(id, text) {
	$('#'+id).bind('ajax:complete', function() {		
		if (document.cookie.match(/no_usb/)) {
			clearFlashes();
			$('.alert:contains("No USB storage detected")').show();	
		} else if (document.cookie.match(/missing_files/)){
			window.location.replace("/");				
		}	else {
			animateFlash($('.alert:contains("'+text+'")'));
		};
	});
}

function animateFlash(element){
  setTimeout(function() {		  	
  	alert = element;
  	width = alert.text().length*(7.5);
  	color = alert.css('color');
  	bgcolor = alert.css('background-color');
  	clearFlashes();
		alert.show();
		alert.animate({ backgroundColor: '#8ECDA6', color: 'black', width: 600 }, 2000);
		alert.animate({ backgroundColor: bgcolor, color: color, width: width }, 2000);
  }, 1000);
}