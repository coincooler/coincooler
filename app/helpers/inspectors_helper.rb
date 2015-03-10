module InspectorsHelper

  def process_uploaded_file(file,password,shares='')
    name = file.original_filename      
    case name[-4..-1]
    when '.csv'
      process_csv(file.path)
    when '.txt'        
      process_aes(file.path,password,shares.to_s.split(/\s+/)) if name =~ /.+#{short_efs}.*#{txt_suffix}$/
    else
      flash[:error] = {message: incorrect_format_flash,title: 'The uploaded file was not in the correct format, try again.',delay_seconds: FLASH_DELAY_SECONDS,id: 'incorrect_format_flash'}
      redirect_to uploads_path
    end   
  end

  def process_csv(path)
    csv_data=CSV.read(path)
    address_or_key(csv_data)    
  end

  def process_aes(path,password,shares_array)      
    password=PasswordJoiner.new(shares_array).password if password.blank?      
    process_aes_with_password(path,password)        
  end

  def process_aes_with_password(path,password)      
    begin
      decrypt(password,path)
      decrypted_data=CSV.read(path+'.dec') 
    rescue      
      flash[:error] = {message: wrong_password_flash,title: 'Decryption failed, try again.',delay_seconds: FLASH_DELAY_SECONDS, id: 'wrong_password'}
      redirect_to uploads_path
    else
      address_or_key(decrypted_data)      
    end    
  end

  def address_or_key(csv_data)    
    case csv_data[0].length
    when 2
      process_addresses(csv_data)
    when 3
      process_private_keys(csv_data)    
    else
      flash[:error] = {message: incorrect_format_flash,title: 'The uploaded file was not in the correct format, try again.',delay_seconds: FLASH_DELAY_SECONDS,id: 'incorrect_format_flash'}
      redirect_to uploads_path        
    end   
  end

  def process_addresses(csv_data)
    if addresses_csv_format?(csv_data)
      @keys=build_addresses_hash_array(csv_data)
      $keys = @keys
      redirect_to inspect_addresses_path
    else
      flash[:error] = {message: incorrect_format_flash,title: 'The uploaded file was not in the correct format, try again.',delay_seconds: FLASH_DELAY_SECONDS,id: 'incorrect_format_flash'}
      redirect_to uploads_path
    end    
  end

  def process_private_keys(csv_data)
    if private_keys_csv_format?(csv_data)
      @keys=build_private_keys_hash_array(csv_data)
      $keys = @keys
      # sleep 10 # to test pbkdf alert flash
      redirect_to inspect_keys_path
    else
      flash[:error] = {message: incorrect_format_flash,title: 'The uploaded file was not in the correct format, try again.',delay_seconds: FLASH_DELAY_SECONDS,id: 'incorrect_format_flash'}
      redirect_to uploads_path
    end
  end  

  def redirect_on_refresh
    redirect_to uploads_path if $keys.blank?
  end
	
end
