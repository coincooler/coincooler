
function setObserver(target_dom) {
	console.log('Observer turned on');
	var targetNodes = $(target_dom);
	var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
	var myObserver = new MutationObserver (mutationHandler);
	var obsConfig = { childList: true, characterData: true, attributes: true, subtree: true };

	targetNodes.each(function(){
	    myObserver.observe(this, obsConfig);
	});

	function mutationHandler (mutationRecords) {
		var ar=[];
	    mutationRecords.forEach ( function (mutation) {
	        if (typeof mutation.addedNodes == "object") {
	            $.each($('td.name a'), function( index, value ) {
  							// console.log( index + ": " + $(this).attr('title') );
  							if (ar.indexOf($(this).attr('title'))<0)  {ar.push($(this).attr('title'));}
							});							
 						observersDuties()
	        }
	    });	  	
	  togglePasswordInput(ar);	  
	}	
};

function setFakeObserverOnRp(target_dom) {
	$('div.row.fileupload-buttonbar').on('click',function () {					
	  setInterval(function(){
	    triggerOnUpload();
	  }, 2000);
	});
	var targetNodes = $(target_dom);
	var MutationObserver = window.MutationObserver
	var myObserver = new MutationObserver ();	
};

function setOldObserver(target_dom) {
	$(target_dom).bind("DOMSubtreeModified", function() {
			console.log('Old Observer activated')
	    triggerOnUpload();
	});	
};