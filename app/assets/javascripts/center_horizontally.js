$.fn.horiz_center_fixed = function() {
    this.css({
        'position': 'fixed',
        'left': '50%',
        // 'top': '50%'
    });
    this.css({
        'margin-left': -this.outerWidth() / 2 + 'px',
        // 'margin-top': -this.outerHeight() / 2 + 'px'
    });

    return this;
};

$.fn.horiz_center_scroll = function() {


    this.css({
        'margin-left': getMargin(this.outerWidth()) + '%',
        // 'margin-top': -this.outerHeight() / 2 + 'px'
    });
    // this.css({
    //     'margin-left': percent + '%',
    //     // 'margin-top': -this.outerHeight() / 2 + 'px'
    // });
    return this;
};

function getMargin(outer){
    // console.log('outer: '+outer);
    var inner=window.innerWidth;
    // console.log('inner: '+inner);    
    var side=(inner-outer)/2;
    // console.log('side: '+side);
    var percent=(side/inner).toFixed(2)*100-1;
    // console.log('percent: '+percent);    
    return percent;
}

