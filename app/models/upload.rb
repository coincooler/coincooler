class Upload < ActiveRecord::Base
  has_attached_file :upload,
  :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
  :path => ":rails_root/files/uploads/"+ID.to_s+"/system/:class/:attachment/:id/:style/:basename.:extension"

  do_not_validate_attachment_file_type :upload
  include Rails.application.routes.url_helpers
  
  def to_jq_upload
    {
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url,
      "delete_url" => upload_path(self),
      "delete_type" => "DELETE" 
    }
  end

end
