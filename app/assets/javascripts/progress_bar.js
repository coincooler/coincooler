// $('.bar').animate(
//     {width:'100%'}, 
//     {
//         duration:5000,
//         step: function(now, fx) {
//             var data= Math.round(now);
//             $(this).html(data + '%');
            
//         }
//     }        
// );

function setProgressbarSeconds(x){
	$('.bar').animate(
	    {width:'100%'}, 
	    {
	        duration:(x*1000),
	        step: function(now, fx) {
	            var data= Math.round(now);
	            $(this).html(data + '%');
	            
	        }
	    }        
	);	
}