function clearFlashes() {
	$('.alert-success').hide();$('.alert-error').hide();$('.alert-info').hide();
}
function popFlash(id, text) {
	$('#'+id).bind('ajax:complete', function() {
		clearFlashes();
		if (document.cookie.match(/no_usb/)) {
			$('.alert:contains("No USB storage detected")').show().delay(slow).fadeOut(fade);	
		} else if (document.cookie.match(/missing_files/)){
			window.location.replace("/");				
		}	else {
			$('.alert:contains("'+text+'")').show().delay(slow).fadeOut(fade);	
		};
	});
}