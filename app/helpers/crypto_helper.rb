module CryptoHelper

	def encrypt(password,file_path)
		raise "Cannot encrypt #{file_path} because the file does not exist" unless File.exist?(file_path)
		case ENCRYPTION_LIBRARY
		when 'Kingslayer'
			Rails.logger.info('Encrypting with Kingslayer using PBKDF2_HMAC with '+PBKDF2_ITERATIONS.to_s+' iterations.')
			encrypt_with_kingslayer(password,file_path)
		else
			Rails.logger.info('Encrypting with Gibberish using KEYIVGEN')
			encrypt_with_gibberish(password,file_path)
		end
	end

	def decrypt(password_or_key,file_path)
		raise "Cannot decrypt #{file_path} because the file does not exist" unless File.exist?(file_path)
		case ENCRYPTION_LIBRARY
		when 'Kingslayer'
			Rails.logger.info('Decrypting with Kingslayer using PBKDF2_HMAC with '+PBKDF2_ITERATIONS.to_s+' iterations.')
			decrypt_with_kingslayer(password_or_key,file_path)
		else
			Rails.logger.info('Decrypting with Gibberish using KEYIVGEN')
			decrypt_with_gibberish(password_or_key,file_path)
		end
	end

	def self.check_pbkdf2
		begin
			Rails.logger.info('Attempting to use Kingslayer for encryption')
			ks=Kingslayer::AES.new(password: 'foobar',iter: 2)
			ks.encrypt('foobar')
			Rails.logger.info('Success, PBKDF2_HMAC is implemented on this machine, proceeding to use Kingslayer for encryption')
			return 'Kingslayer'
		rescue NotImplementedError => e
			Rails.logger.info('Ooops, looks like PBKDF2_HMAC is not implemented on this machine, switching to encryption using Gibberish')
			return 'Gibberish'
		end
	end	

	private

		def encrypt_with_kingslayer(password,file_path)		
			if password
				Rails.logger.info('The password `'+password+'` was given, stretching '+PBKDF2_ITERATIONS.to_s+' times')
				ks = Kingslayer::AES.new(password: password,iter: PBKDF2_ITERATIONS)	
			else
				Rails.logger.info('No password was given, generating a random key and stretching only once')
				ks = Kingslayer::AES.new()
			end			
			ks.encrypt_file(file_path,file_path+encrypted_file_suffix)
			ks.password 
		end

		def decrypt_with_kingslayer(password_or_key,file_path)
			Rails.logger.info('the key is: '+password_or_key)
			begin
				Rails.logger.info('first assume its a key and try to decrypt without stretching which should be quick')
				ks=Kingslayer::AES.new(password: password_or_key)
				ks.decrypt_file(file_path,file_path+'.dec')				
			rescue 
				Rails.logger.info('that failed so now assume its a password and stretch it')
				ks = Kingslayer::AES.new(password: password_or_key,iter: PBKDF2_ITERATIONS)
				ks.decrypt_file(file_path,file_path+'.dec')			
			end
		end

		def encrypt_with_gibberish(password,file_path)
			password = generate_key_on_heroku if password.blank?
			cipher = Gibberish::AES.new(password)
			cipher.encrypt_file(file_path,file_path+encrypted_file_suffix)
			password 
		end

		def decrypt_with_gibberish(password,file_path)
			cipher = Gibberish::AES.new(password)
			cipher.decrypt_file(file_path,file_path+'.dec')
		end

    def generate_key_on_heroku
      s = ''
      32.times {s << rand(255).chr}
      s.unpack('H*')[0]
    end		
end

# on heroku i get:

# 2014-05-12T07:48:58.331297+00:00 app[web.1]: Completed 500 Internal Server Error in 17ms
# 2014-05-12T07:48:58.332430+00:00 app[web.1]:   app/helpers/kingslayer.rb:49:in `encrypt'
# 2014-05-12T07:48:58.332427+00:00 app[web.1]:   app/helpers/kingslayer.rb:102:in `pbkdf2_hmac'
# 2014-05-12T07:48:58.332425+00:00 app[web.1]: NotImplementedError (pbkdf2_hmac() function is unimplemented on this machine):
