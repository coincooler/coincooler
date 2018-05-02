class KeyGenerator
	require 'bitcoin'
	attr_reader :keys, :howmany

	def initialize(num)
		if num.class == Integer && num.positive?
			@howmany = num
		else
			raise 'must initialize with a positive integer'
		end
		@keys = generate_keys_array(@howmany)
	end

	private

	def generate_keys_array(num)
		num.times.each_with_object([]) { |n, result| result << Bitcoin::Key.generate }
	end
end
