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
		it "should reside under the /media location" do
			usb_path[0..('/media/'.length-1)].should == '/media/'
		end
		it { usb_path.should == '/media/usb1/' }
		it { usb_path(2).should == '/media/usb2/' }
		it { usb_path(nil).should == '/dev/null/' }
		describe "dynamic usb" do
			it "should be nil or an integer" do
				dynamic_usb_mount.to_s.to_i.should be_integer
				dynamic_usb_mount(2).should == 2
				dynamic_usb_mount(nil).should be_nil
			end
		end
	end
	describe "remove params" do
		it{ remove_params('localhost:3000/new_keys').should == 'localhost:3000/new_keys' }
		it{ remove_params('localhost:3000/new_keys?expose=prvkey_qr_btn_1').should == 'localhost:3000/new_keys' }
	end
	describe "number to lower case letter" do
		it { number_to_letter(1).should == 'a' }
		it { number_to_letter(26).should == 'z' }
		it { number_to_letter(2).should == 'b' }
		it { number_to_letter(0).should be_nil }
		it { number_to_letter(27).should be_nil }
	end
	describe "really attached?" do
		it { really_attached?('fdisk: unable to open /dev/sde1: Permission denied').should be_true }
		it { really_attached?('fdisk: unable to open /dev/sdd1: No such file or directory').should be_false }
		it { really_attached?('fdisk: unable to open /dev/sd1: No such file or directory').should be_false }
	end
	describe "dynamic_usb_really_attached?" do
		it { dynamic_usb_really_attached?(nil).should be_false}
		it { dynamic_usb_really_attached?(0).should be_false}
		it { dynamic_usb_really_attached?(27).should be_false}
		it { dynamic_usb_really_attached?(1).should be_true}
	end
end