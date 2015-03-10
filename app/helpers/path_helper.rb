module PathHelper
	require 'open3'

	def relative_root_path
		File.expand_path(Rails.root) +'/'
	end
	def remove_params(path_with_params)
		s=path_with_params.index('?').to_i
		s>0 ? path_with_params[0..(s-1)] : path_with_params
	end
	def dieharder_scorecard
		relative_root_path+'public/dieharder'
	end

	def cold_storage_directory_name
		'Cold_Storage_'+Time.now.strftime("%Y-%m-%d#{$tag}/").to_s
	end

	def usb_path(test_usb_num=1)
		tmp=dynamic_usb_mount(test_usb_num)
		if tmp
			return '/media/usb'+tmp.to_s+'/'
		else
			return '/dev/null/' 
		end		
	end
	def jquery_uploads_dir
		relative_root_path + 'files/uploads/'
	end
	def jquery_uploads_path(string)		
		jquery_uploads_dir+string.to_s+'/'
	end
	def coldstorage_directory(usb=false)
		if usb
			return usb_path + cold_storage_directory_name			
		else
			return relative_root_path + 'files/'
		end		
	end

	def unless_usb(bool,string)
		return '' if bool
		string
	end

	def file_fixtures_directory
		relative_root_path +  'spec/fixtures/files/'
	end

	def public_directory_path(usb=false)
		coldstorage_directory(usb) + unless_usb(usb,'public/')
	end
			
	def private_directory_path(usb=false)
		coldstorage_directory(usb) +  unless_usb(usb,'PRIVATE/')
	end

	def encrypted_directory_path(usb=false)
		private_directory_path(usb) +  unless_usb(usb,'encrypted/')
	end

	def unencrypted_directory_path(usb=false)
		private_directory_path(usb) +  unless_usb(usb,'NON-ENCRYPTED/')
	end	

	def addresses_file_name
		'addresses'
	end	
	def private_keys_file_name
		'private_keys'
	end
	def password_file_name
		'password'
	end	
	def password_share_file_name
		'password_share'
	end
	def download_row_file_name
		'private_key'
	end

	def suffix(file_type)
		$tag.to_s+"."+file_type
	end
	def public_addresses_file_path(file_type,usb=false)		
		public_directory_path(usb)+addresses_file_name+suffix(file_type)
	end

	def password_file_path(file_type,usb=false)		
		private_directory_path(usb) + password_file_name+suffix(file_type)
	end

	def private_keys_file_path(file_type,encrypted,usb=false)
		if encrypted
			return encrypted_directory_path(usb)+private_keys_file_name+suffix(file_type)+encrypted_file_suffix
		else
			return unencrypted_directory_path(usb)+private_keys_file_name+suffix(file_type)
		end
	end

	def download_row_file_path(number, usb=false)
		unencrypted_directory_path(usb)+download_row_file_name+'_'+number.to_s+".csv"
	end

	def password_shares_path(number,usb=false)
		raise 'Share number must be positive' unless number > 0
		encrypted_directory_path(usb)+password_share_file_name+'_'+number.to_s+suffix('csv')
	end

	def dynamic_usb_mount(test_usb_num=1)
		if Rails.env=='test'
			return test_usb_num
		else
			regy=/(\/media\/usb)(\d+)(\s+type)/
			return `mount;`.scan(regy).map{|x| p x[1].to_i}.max;
		end
	end
	def number_to_letter(number)
		(number+96).chr if (1..26).include?(number)
	end
	def really_attached?(string)
		string.match(/^fdisk: unable to open \/dev\/sd\w\d: Permission denied/).to_a.length > 0
	end
	def get_fdisk(dynamic_usb_mount)
		Open3.popen3('fdisk /dev/sd'+number_to_letter(dynamic_usb_mount.to_i).to_s+'1') { |stdin, stdout, stderr, wait_thr| stderr.read }		
	end
	def dynamic_usb_really_attached?(number)
		really_attached?(get_fdisk(number).chomp)
	end
  def set_copy_cookie
  	if dynamic_usb_really_attached?(dynamic_usb_mount)
  		cookies[:copy] = 'usb'
  	else
  		cookies[:copy] = 'no_usb'
  	end
  end
  def usb?
  	COPY && dynamic_usb_really_attached?(dynamic_usb_mount)  	
  end
  def set_tag
    if Rails.env=='test'
      tag='_test_'
    elsif Rails.env=='development'
      tag='_dev_'
    else
      tag='_'
    end
    $tag=tag+rand(100000..999999).to_s 
  end
  def short_efs
  	'.enc'
  end
  def txt_suffix
  	'.txt'
  end
  def short_dfs
  	'.dec'
  end
  def encrypted_file_suffix
  	short_efs + txt_suffix
  end
  def decrypted_file_suffix
  	encrypted_file_suffix+short_dfs
  end
end