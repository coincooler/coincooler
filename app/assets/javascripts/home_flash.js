if (document.cookie.match(/missing_files/)) {
	$('.alert:contains("An error occured, please try again")').show().delay(delay).fadeOut(fade);
	$( document ).ready(function() {  
		document.cookie='copy=';
	});
};
// if (document.cookie.match(/clear/)) {
// 	document.cookie='copy=';
// }