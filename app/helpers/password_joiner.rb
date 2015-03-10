class PasswordJoiner
	require 'shamir-secret-sharing'
	attr_reader :password

	def initialize(shares_array)
		raise 'expected an array of shares' unless shares_array.class == Array
		password=ShamirSecretSharing::Base58.combine(shares_array.uniq)
		@password=password if password
	end

end
