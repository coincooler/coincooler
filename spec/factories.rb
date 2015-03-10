FactoryGirl.define do
  factory :upload do
    upload_file_name     "foo.csv"
		upload_content_type 	"text/csv"
		upload_file_size 100
		# upload_updated_at "2014-06-16 11:27:44"
		# created_at "2014-06-16 11:27:44"
		# updated_at "2014-06-16 11:27:44"
  end
end