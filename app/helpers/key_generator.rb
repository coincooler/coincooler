class KeyGenerator
	
	require 'bitcoin'

	attr_reader :keys, :howmany

	def initialize(num)
		if num.class==Fixnum && num>0
			@howmany=num	
		else
			raise 'must initialize with a positive integer'
		end		
		@keys=generate_keys_array(@howmany)
	end

	private

	def generate_keys_array(num)
		result=[]
		num.times do |entry|
			result << Bitcoin::Key.generate
		end
		result
	end

end