
$('.hiddenPrvkey').click(exposePrivateKey);
$('.hiddenPassword').click(exposePassword);
$('#minus').toggle();
$('#up').toggle();
$('#advanced_options').click(toggleAdvancedOptionsLink);
// $('#coldstorage_what_link').click(toggleAdvancedOptionsLink);
// $('#generate_button').css('font-size',14);

if (getSsssN() != null) {capSsssK(getSsssN());};
if ($('.file_upload').length > 0) {hideShares();};

$( document ).ready(function() {  
  $('body').show();
  $('.forcenter_horiz').horiz_center_scroll();
});

window.onresize = function() {
    $('.forcenter_horiz').horiz_center_scroll();
    alignDeleteAll();
    fixFooter();
};