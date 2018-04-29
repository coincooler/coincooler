require 'spec_helper'

describe PathHelper do
	describe "path selection" do
		it "should choose the right path for unencrypted" do
			private_keys_file_path('foo',false).should == unencrypted_directory_path + private_keys_file_name + $tag.to_s + '.foo'
		end
		it "should choose the right path for encrypted" do
			private_keys_file_path('foo',true).should == encrypted_directory_path + private_keys_file_name + $tag.to_s + '.foo'+encrypted_file_suffix
		end
	end

	describe "usb vs internal path selection" do
		it "should work for public dir" do
			public_directory_path.should == relative_root_path +  'files/public/'
			public_directory_path(true).should == usb_path + cold_storage_directory_name
		end

		it "should work for public file path" do
			public_addresses_file_path('csv').should == relative_root_path +  'files/public/' +addresses_file_name + $tag.to_s + '.csv'
			public_addresses_file_path('csv',true).should == usb_path + cold_storage_directory_name	 + addresses_file_name + $tag.to_s + '.csv'
		end

		it "should work for PRIVATE dir" do
			private_directory_path.should == relative_root_path +  'files/PRIVATE/'
			private_directory_path(true).should == usb_path + cold_storage_directory_name
		end

		it "should work for encrypted dir" do
			encrypted_directory_path.should == relative_root_path +  'files/PRIVATE/encrypted/'
			encrypted_directory_path(true).should == usb_path + cold_storage_directory_name
		end

		it "should work for NON-ENCRYPTED dir" do
			unencrypted_directory_path.should == relative_root_path +  'files/PRIVATE/NON-ENCRYPTED/'
			unencrypted_directory_path(true).should == usb_path + cold_storage_directory_name
		end

		it "should work for unencrypted private file path" do
			private_keys_file_path('csv',false).should == relative_root_path +  'files/PRIVATE/NON-ENCRYPTED/' +private_keys_file_name + $tag.to_s + '.csv'
			private_keys_file_path('csv',false,true).should == usb_path + cold_storage_directory_name	 + private_keys_file_name + $tag.to_s + '.csv'
		end

		it "should work for encrypted private file path" do
			private_keys_file_path('csv',true).should == relative_root_path +  'files/PRIVATE/encrypted/' +private_keys_file_name + $tag.to_s + '.csv'+encrypted_file_suffix
			private_keys_file_path('csv',true,true).should == usb_path + cold_storage_directory_name	 + private_keys_file_name + $tag.to_s + '.csv'+encrypted_file_suffix
		end

		it "should work for password shares file path" do
			password_shares_path(1).should == relative_root_path +  'files/PRIVATE/encrypted/' +password_share_file_name+'_1'+ $tag.to_s + '.csv'
			password_shares_path(1,true).should == usb_path + cold_storage_directory_name + password_share_file_name + '_1' + $tag.to_s + '.csv'
		end

		it "should work for one key path" do
			download_row_file_path(1, true).should == usb_path + cold_storage_directory_name + download_row_file_name + '_1.csv'
		end
	end

	describe "usb_path" do
		it "should reside under the media directory" do
			usb_path[0..("/#{media_dir}/".length-1)].should == "/#{media_dir}/"
		end
	end

	describe "remove params" do
		it{ remove_params('localhost:3000/new_keys').should == 'localhost:3000/new_keys' }
		it{ remove_params('localhost:3000/new_keys?expose=prvkey_qr_btn_1').should == 'localhost:3000/new_keys' }
	end
end
