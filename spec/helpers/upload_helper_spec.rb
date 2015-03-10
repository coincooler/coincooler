require 'spec_helper'
# include UploadHelper
	include PathHelper

describe UploadHelper do	
	let!(:up) { FactoryGirl.create(:upload, upload_file_name: 'testfile.csv') }	
	let!(:oldie) { FactoryGirl.create(:upload, upload_file_name: 'old.csv', created_at: 2.hours.ago) }
	let!(:newbie) { FactoryGirl.create(:upload, upload_file_name: 'new.csv', created_at: 50.minutes.ago) }
	let!(:url) { "system/uploads/uploads/000/000/084/original/40private_keys.csv?1402993102" }
	# describe "get_path" do
	# 	it "should get just the path without the number at the end" do
	# 		strip_url_to_absolute_path(url).should == jquery_uploads_path(ID)+"system/uploads/uploads/000/000/084/original/40private_keys.csv"
	# 		strip_url_to_absolute_path('quuax.csv').should == jquery_uploads_path(ID)+'quuax.csv'
	# 	end
	# end
	describe "fresh?" do
		it "should return true only if file is not more than an hour old" do
			fresh?(oldie).should be_false
			fresh?(newbie).should be_true
		end
	end
	describe "valid" do
		it "should accept only .csv and .csv.enc.txt" do
			
		end
	end
end