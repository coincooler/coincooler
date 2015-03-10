module QrHelper
	
	require 'rqrcode'

	def generate_qr(string)
		RQRCode::QRCode.new( string, :size => 6, :level => :h )		
	end	

end


# address_hash[:qr_address] = RQRCode::QRCode.new( address_hash[:address], :size => 8, :level => :h )
# address_hash[:qr_prvkey] = RQRCode::QRCode.new( address_hash[:prvkey], :size => 8, :level => :h )