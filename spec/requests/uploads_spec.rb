require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper 

describe "Uploads:" do	
	let!(:test_pa) { file_fixtures_directory+'valid/10_addresses.csv' }		
	let!(:test_pk) { file_fixtures_directory+'valid/10_private_keys.csv' }
	let!(:test_ek) { file_fixtures_directory+'valid/2_private_keys_moohaha.csv'+encrypted_file_suffix }
	let!(:test_ek2) { file_fixtures_directory+'valid/2_private_keys_moohaha.csv'+short_efs+' (1)'+txt_suffix }	
	let!(:encrypted_pkss_path) { file_fixtures_directory+'valid/private_keys_wherethewildthingsare.csv'+encrypted_file_suffix }
	let!(:pass_path) { file_fixtures_directory+'valid/password_wherethewildthingsare.csv' }	
	let!(:share_1_path) { file_fixtures_directory+'valid/password_share_1_wherethewildthingsare.csv' }	
	let!(:share_2_path) { file_fixtures_directory+'valid/password_share_3_wherethewildthingsare.csv' }	
	let!(:share_3_path) { file_fixtures_directory+'valid/password_share_5_wherethewildthingsare.csv' }			
	subject { page }
	before(:all) do
		delete_all
	end
	before do
		delete_all
		visit uploads_path
	end
	describe "uploads page" , :js => true, slow: true do
		it_should_behave_like 'the empty uploads page'	
	end	
	describe "if attached file is not there", :js => true, slow: true do
		before do
			delete_all
			jquery_attach_file('upload_upload', test_pa)
			sleep 1
			nuke_all_uploads
		  click_button recover_button		  
		end
		it "should stay on uploads page and flash error" do			
			URI.parse(current_url).request_uri.should == uploads_path
			should have_title(uploads_title)
			should have_selector('div.alert.alert-error', text: missing_file_error)
		end
		it_should_behave_like 'the empty uploads page'
	end
	describe "uploads page after uploading one unencrypted file", :js => true, slow: true do
	  before do
	  	visit uploads_path
			delete_all
	  	jquery_attach_file('upload_upload', test_pa)	  	
	  end
	  it "should disable the upload button, show the new uploaded file but no password or upload checkbox" do
			page.should have_title full_title(uploads_title) 			
			page.should have_css('span.fileinput-button.disabled') 
			page.should have_xpath("//input[@type='checkbox'][@id='upload_del_all']")
			# page.should have_button 'Cancel upload'
			page.should have_button 'del_all'
			page.should have_button 'delbut'
			page.should have_selector('td.name a', text: '10_addresses.csv')			
			page.should have_button recover_button
			page.should_not have_selector('input#keyboard.input-xxlarge')
			page.should_not have_selector('input#upload_shares')
	  end
	end
	describe "files with invalid format", :js => true, slow: true do
		['foo.bar','invalid_address.csv','invalid_addresses_format.csv','invalid_addresses_header.csv','invalid_format.csv','invalid_header_format.csv','invalid_prvkey_format.csv','prkey_with_invalid_address.csv','prkey_with_non_matching_key_pairs.csv'].each do |name|		
			describe name do		
				before do
					delete_all
					jquery_attach_file('upload_upload', file_fixtures_directory+'invalid/'+name)					
					click_button recover_button
				end
				it "should stay on uploads page and flash error" do
					URI.parse(current_url).request_uri.should == uploads_path
					should have_selector('div.alert.alert-error', text: /(#{incorrect_format_flash}|#{missing_file_error})|#{upload_format_error}/)
				end
			end
		end				
	end	
	describe "loading an addresses csv file", :js => true, slow: true do
	  before do
			delete_all
	  	jquery_attach_file('upload_upload', test_pa) 
	  	click_button recover_button
	  end	  
		it "should behave like the addresses page" do	
			URI.parse(current_url).request_uri.should==inspect_addresses_path
			page.should have_title full_title(addresses_title)
			page.should have_selector('th', text: addresses_header)
			page.should_not have_selector('th', text: keys_header)
			page.should have_selector('td.text_pubkey#address_1', text: '1PUBCSPrspWYz6FdJ1CX3SFoQg96Zr62RS')
			page.should have_selector('td.text_pubkey#address_10', text: '1CXaVvECDcvBb8PFMJAsCPGhqkKwP1tD8K')
			page.should_not have_selector('td.text_pubkey#address_11')
		end
		describe "download upload link should" do
			describe "save the uploaded addresses file to the usb location" do
				before do
				  click_link download_upload_button
				end					
				specify{File.exist?(coldstorage_directory(true)+File.basename(test_pa)).should be_true }
			end			
		end		
	end
	describe "loading an UN-encrypted private keys csv file", :js => true, slow: true do
	  before do
			delete_all
	  	jquery_attach_file('upload_upload', test_pk)
	  	click_button recover_button
	  	sleep 1 
	  end
		it "should behave like the private keys page, with working QR and no download links" do			
			page.should have_title full_title(private_keys_title)
			page.should have_selector('th', text: addresses_header)
			page.should have_selector('th', text: keys_header)
			page.should have_selector('td.text_pubkey#address_1', text: '15CzKMKshYnsS3w1ujED3WSQ1T38nAs3CC')	
		end
		describe "download row links" do
			describe "download the first row correctly" do
				before { click_link 'download_row_1';sleep 2 }
				describe "the file should be created in the download path" do					
					specify{File.exist?(unencrypted_directory_path(true)+download_row_file_name+'_1.csv').should be_true }						
					describe "and should contain the address and key of the 1st line" do
						let!(:data) { CSV.read(download_row_file_path(1, true)) }
						specify{data[1][1].should == '15CzKMKshYnsS3w1ujED3WSQ1T38nAs3CC'}
						specify{data[1][2].should == '5KSxnAUBqEFcgaFEzMq2HjLfEZa5VzbYBaHPhCv9itAHGLoxAH8'}
					end
				end
				describe "and we should stay on the same page and flash" do
					before { visit old_inspect_keys_path }						
					it { should have_title private_keys_title }						
				end
			end
		end
		describe "download upload link should" do
			describe "save the uploaded keys file to the usb location" do
				before do
				  click_link download_upload_button
				end					
				specify{File.exist?(coldstorage_directory(true)+File.basename(test_pk)).should be_true }
			end			
		end		
	end
	describe "uploads page after uploading one encrypted file", :js => true, slow: true do
	  before do
	  	visit uploads_path
			delete_all
	  	jquery_attach_file('upload_upload', test_ek) 
	  end
	  it "should disable the upload button, show the new uploaded file with enabled password and upload shares checkbox" do
			page.should have_title full_title(uploads_title) 			
			page.should have_css('span.fileinput-button.disabled') 
			page.should have_xpath("//input[@type='checkbox'][@id='upload_del_all']")
			# page.should have_button 'Cancel upload'
			page.should have_button 'del_all'
			page.should have_button 'delbut'
			page.should have_selector('td.name a', text: '2_private_keys_moohaha.csv'+encrypted_file_suffix)			
			page.should have_button recover_button
			page.should have_selector('input#keyboard.input-xxlarge')
			page.should have_selector('input#upload_shares')
			page.should_not have_xpath("//input[@id='keyboard'][@disabled]")
	  end
	end	
	describe "loading an encrypted private keys file with a password", :js => true, slow: true do
	  before do
	  	delete_all
	  	jquery_attach_file('upload_upload', test_ek)
	  	fill_in 'password', with: 'moohaha'
	  	click_button recover_button
	  end
		it "should behave like the private keys page, with working QR and no download links" do			
			page.should have_title full_title(private_keys_title)			
			page.should have_selector('th', text: addresses_header)
			page.should have_selector('th', text: keys_header)			
			page.should have_selector('td.text_pubkey#address_1', text: '1KygS6jWbncUM369z661kKwFdD8S5FmnRy')
		end
	end
	describe "uploads page after uploading one encrypted file and clicking the uploads shares checkbox", :js => true, slow: true do
	  before do
	  	visit uploads_path
			delete_all
	  	jquery_attach_file('upload_upload', test_ek)
	  	page.check('upload_shares')
	  end
	  it "should enable the upload button, show the new uploaded file with disabled password" do
			page.should have_title full_title(uploads_title) 			
			page.should_not have_css('span.fileinput-button.disabled') 
			page.should have_xpath("//input[@type='checkbox'][@id='upload_del_all']")
			# page.should have_button 'Cancel upload'
			page.should have_button 'del_all'
			page.should have_button 'delbut'
			page.should have_selector('td.name a', text: '2_private_keys_moohaha.csv'+encrypted_file_suffix)			
			page.should have_button recover_button
			page.should have_selector('input#upload_shares')
			page.should have_xpath("//input[@id='keyboard'][@disabled]")
	  end
	end	
	describe "loading an encrypted private keys file with 2 shares", :js => true, slow: true do
	  before do
	  	# click_button 'delbut' if page.has_button?('delbut')
	  	visit uploads_path
			delete_all
	  	jquery_attach_file('upload_upload', encrypted_pkss_path)
	  	sleep 1
	  	page.check('upload_shares')
	  	sleep 1
	  	jquery_attach_file('upload_upload', share_1_path, 'seleniumUploadShare1')
	  	sleep 1
	  	jquery_attach_file('upload_upload', share_2_path,'seleniumUploadShare2')
	  	sleep 1
	  	jquery_attach_file('upload_upload', share_3_path,'seleniumUploadShare3')	  		  	
	  	click_button recover_button
	  	sleep 1 
	  end
		it "should behave like the private keys page, with working QR and no download links" do			
			page.should have_title full_title(private_keys_title)			
			page.should have_selector('th', text: addresses_header)
			page.should have_selector('th', text: keys_header)
			page.should have_selector('td.text_pubkey#address_1', text: '1Hkdv7Ess2pVAU3tZCKpY85TK9tWz9C3qd')	
		end
		after do
			delete_all
		end
	end
	describe "loading an encrypted private keys file and a password file", :js => true, slow: true do
	  before do
	  	# click_button 'delbut' if page.has_button?('delbut')
	  	visit uploads_path
			delete_all
	  	jquery_attach_file('upload_upload', encrypted_pkss_path)
	  	sleep 1
	  	page.check('upload_password')
	  	sleep 1
	  	jquery_attach_file('upload_upload', pass_path, 'seleniumUploadShare1')  		  	
	  	click_button recover_button
	  	sleep 1 
	  end
		it "should behave like the private keys page, with working QR and no download links" do			
			page.should have_title full_title(private_keys_title)			
			page.should have_selector('th', text: addresses_header)
			page.should have_selector('th', text: keys_header)
			page.should have_selector('td.text_pubkey#address_1', text: '1Hkdv7Ess2pVAU3tZCKpY85TK9tWz9C3qd')	
		end
		after do
			delete_all
		end
	end
	describe "relaxing encrypted file naming to allow conflict resolution during browser download with a password", :js => true, slow: true do
	  before do
	  	delete_all
	  	jquery_attach_file('upload_upload', test_ek2)
	  	fill_in 'password', with: 'moohaha'
	  	click_button recover_button
	  end
		it "should behave like the private keys page" do			
			page.should have_title full_title(private_keys_title)			
		end
	end
end
