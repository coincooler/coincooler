class PasswordSplitter
	require 'shamir-secret-sharing'
	require 'openssl'
	
	attr_reader :k, :n, :shares, :password

	def initialize(n=5,k=3,password=OpenSSL::Cipher::AES256.new(:CBC).random_key.unpack('H*')[0])
		@password=password
		@k=k
		@n=n
		@shares=ShamirSecretSharing::Base58.split(secret=@password, available=@n, needed=@k)
	end

end
