module ConnectionHelper
	require 'open-uri'
	
	def self.internet_connection?
	  begin
	    true if open("http://www.google.com/")
	  rescue
	    false
	  end
	end	
end