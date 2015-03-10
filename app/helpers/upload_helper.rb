module UploadHelper
	include PathHelper

	# def strip_url_to_absolute_path(upload_object_url)
	# 	url=(jquery_uploads_path(ID)+upload_object_url)
	# 	url[0..(url.index('?').to_i-1)]
	# end

	# def get_absolute_path(upload_object)
	# 	raise 'not an upload object' unless upload_object.class.to_s == 'Upload'
	# 	strip_url_to_absolute_path(upload_object.upload.url)
	# end

	def fresh?(upload_object)
		return false unless upload_object.class.to_s == 'Upload'
		((Time.now-upload_object.created_at)/1.minute).round<60
	end

	def there?(upload_object)
		return false unless upload_object.class.to_s == 'Upload'
		file_there?(upload_object.upload.path)
	end
	def get_shares(upload_object_array)		
    shares=''
    upload_object_array.each do |upload_object|
    	begin
	      data = CSV.read(upload_object.upload.path)
	      if share_csv_format?(data) then
		      share = data[1][0]
		      shares<<share+ " "      	
	      end
			rescue
			end	      
    end
    return shares.strip
	end
	def get_password(upload_object_array)		
    password=''
    upload_object_array.each do |upload_object|
    	begin
	      data = CSV.read(upload_object.upload.path)
	      if password_csv_format?(data) then
		      pass = data[1][0]
		      password<<pass
	      end
			rescue
			end	      
    end
    return password.strip unless password.blank?
	end	
end

