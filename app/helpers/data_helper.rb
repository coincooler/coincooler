module DataHelper

	def build_addresses_hash_array(addresses_csv) 
		result=[]
		addresses_csv.shift
		addresses_csv.each do |row|
			result << {addr: row[1]}
		end
		result
	end

	def build_private_keys_hash_array(private_keys_csv) 
		result=[]
		private_keys_csv.shift
		private_keys_csv.each do |row|
			result << {addr: row[1],private_wif: row[2]}
		end
		result
	end

end
