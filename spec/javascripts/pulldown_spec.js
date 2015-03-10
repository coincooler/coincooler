//= require spec_helper

describe('getSsssN should return null if no ssss_n id', function(){
  before(function(){
    $('#ssss_n').remove();
  });
  it('should render', function() {    
    var foo = getSsssN();
    expect(foo).to.be.a('null');
  });  
});

describe('getSsssN should return the selected item if ssss_n select on page', function() {
  it('should render', function() {    
    $('#konacha').append('<select id="ssss_n"><option value="3">3</option><option selected="selected" value="4">4</option></select>');
    var foo = getSsssN();
    expect(foo).to.equal('4');
  });
});






