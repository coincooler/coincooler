function getSsssN(){
	var e = document.getElementById("ssss_n");
	if (e!=null) {return e.options[e.selectedIndex].text;} else {return null;};
}

function getShareNumber(){
	var e = document.getElementById("howmany");
	if (e!=null) {return e.options[e.selectedIndex].text;} else {return null;};
}

// function capSsssK(x){
// 	var e = document.getElementById("ssss_k");
// 	for (var i = e.options.length - 1; i >= 0; i--) {
// 		if (i>(x-3)) {e.remove(i);};
// 	};
// }

function capSsssK(x){	
	var l = $('#ssss_k option').length;		
	if (l>0) {
		for (var i = l; i > 0; i--) {
			if (i>(x-3)) {$("#ssss_k option[value="+(i+2)+"]").hide();} else {$("#ssss_k option[value="+(i+2)+"]").show();};
		};		
	};
};

function hideShares(){	
	$("#upload_shares_header").hide();
	var l = $('table#upload_shares td').length;
	if (l>0) {
		for (var i = l; i > 0; i--) {
			$("#password_share_"+i).hide();
		};		
	};
};


function showShares(){	
	hideShares();	
	var n = getShareNumber();
	var l = $('table#upload_shares td').length;
	if (l>=n && n>0) {
		$("#upload_shares_header").show();
		for (var i = n; i > 0; i--) {
			$("#password_share_"+i).show();
		};		
	};
};
