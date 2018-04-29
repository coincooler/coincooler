require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper

describe "Inspectors:" do
	let!(:test_encrypted_pk_path) { file_fixtures_directory+'valid/2_private_keys_moohaha.csv'+encrypted_file_suffix }
	let!(:test_encrypted_2_path) { file_fixtures_directory+'valid/2_private_keys_moohaha.csv'+short_efs+' (1)'+txt_suffix }
	subject { page }
	before { visit old_inspect_path }
	it_should_behave_like 'the inspect page'

	describe "flash error and stay on inspect page if no file was
	attached" do
		before { click_button recover_button }
		it_should_behave_like 'the inspect page'
		it { should have_selector('div.alert.alert-error', text: no_file_loaded_flash)}
	end

	describe "loading an addresses csv file" do
		let!(:test_pa_path) { file_fixtures_directory+'valid/10_addresses.csv' }

		before do
		  attach_file "file", test_pa_path
		  click_button recover_button
		end

		it_should_behave_like 'the addresses page'
		it_should_behave_like 'the QR buttons are working'
		it_should_behave_like 'it does not have download buttons'

		describe "and show the addresses correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: '1PUBCSPrspWYz6FdJ1CX3SFoQg96Zr62RS') }
			it { should have_selector('td.text_pubkey#address_10', text: '1CXaVvECDcvBb8PFMJAsCPGhqkKwP1tD8K') }
			it { should_not have_selector('td.text_pubkey#address_11') }
		end
	end

	describe "loading an unencrypted private keys csv file" do
		let!(:test_unencrypted_pk_path) { file_fixtures_directory+'valid/10_private_keys.csv' }

		before do
		  attach_file "file", test_unencrypted_pk_path
		  click_button recover_button
		end

		it_should_behave_like 'the private keys page'
		it_should_behave_like 'the QR buttons are working'
		it_should_behave_like 'it does not have download buttons'

		describe "should show the keys correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: '15CzKMKshYnsS3w1ujED3WSQ1T38nAs3CC') }
			it { should have_selector('td.text_prvkey#prvkey_wif_10', text: '5KCG1j27PTVojXXZLf389rKr9PmgiE64NyDQbxFCx1V3c6qtUK4') }
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }
			it { should_not have_selector('td.text_pubkey#address_11') }

			describe "download row links" do
				describe "download the first row correctly" do
					before { click_link 'download_row_1' }
					describe "the file should be created in the download path" do

						specify do
							File.exist?(unencrypted_directory_path(true)+download_row_file_name+'_1.csv').should be_true
						end

						describe "and should contain the address and key of the 1st line" do
							let!(:data) { CSV.read(download_row_file_path(1, true)) }
							specify { private_keys_csv_format?(data).should be_true }
							specify { data[1][1].should == '15CzKMKshYnsS3w1ujED3WSQ1T38nAs3CC' }
							specify { data[1][2].should == '5KSxnAUBqEFcgaFEzMq2HjLfEZa5VzbYBaHPhCv9itAHGLoxAH8' }
						end
					end

					describe "and we should stay on the same page and flash" do
						before { visit old_inspect_keys_path }
						it { should have_title private_keys_title }
					end
				end

				describe "download the third row correctly" do
					before { click_link 'download_row_3' }
					describe "the file should be created in the download path" do
						specify{File.exist?(download_row_file_path(3, true)).should be_true }
						describe "and should contain the address and key of the 3rd line" do
							let!(:data) { CSV.read(download_row_file_path(3, true)) }
							let!(:base) { CSV.read(file_fixtures_directory+'valid/10_private_keys_download_3rd_row.csv') }
							specify{data.should == base}
						end
					end
				end
			end
		end
	end
	describe "loading an encrypted private keys csv.enc.txt file with a password" do
		before do
		  attach_file "file", test_encrypted_pk_path
		  fill_in 'password', with: 'moohaha'
		  click_button recover_button
		end
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it does not have download buttons'
		describe "should show the keys correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: '1KygS6jWbncUM369z661kKwFdD8S5FmnRy') }
			it { should have_selector('td.text_prvkey#prvkey_wif_2', text: '5J2YEY3T7tt4L68ptdgB5Ro93FRa3tR9jHZp68NQKHE42kKGCY3') }
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }
			it { should_not have_selector('td.text_pubkey#address_3') }
		end
	end
	describe "loading an encrypted private keys csv.enc(1).txt file with a password" do
		before do
		  attach_file "file", test_encrypted_2_path
		  fill_in 'password', with: 'moohaha'
		  click_button recover_button
		end
		it_should_behave_like 'the private keys page'
	end
	# describe "loading an encrypted private keys csv.enc file with 3 ssss shares using the text interface" do
	# 	let!(:encrypted_pkss_path) { file_fixtures_directory+'valid/private_keys_assafassaf.csv'+es }
	# 	before do
	# 	  attach_file "file", encrypted_pkss_path
	# 	  fill_in 'shares', with: "2bc5HgiLpSpi894Cn6z5U1rK\nYxNt2LU7SvwFEeNtP4QDLHD\njrVYp4yvCoGMuCyWwCVALi4"
	# 	  click_button recover_button
	# 	end
	# 	it_should_behave_like 'the private keys page'
	# 	it_should_behave_like 'it does not have download buttons'
	# 	describe "should show the keys correctly" do
	# 		it { should have_selector('td.text_pubkey#address_1', text: '1EZKzT9W5kwg6RXdG3NcRiGoJz8fKSr8t9') }
	# 		it { should have_selector('td.text_prvkey#prvkey_wif_3', text: '5JfnGDBJTVLXo7HBJB4c3sKYBAtz6oUxaVpcDMj554CGi1avF47') }
	# 		it { should have_selector("td#qr_address_2") }
	# 		it { should have_selector("td#qr_prvkey_wif_2") }
	# 		it { should_not have_selector('td.text_pubkey#address_11') }
	# 	end
	# end
	# describe "loading an encrypted private keys csv.enc file with 3 ssss shares using the share file upload interface" do
	# 	let!(:encrypted_pkss_path) { file_fixtures_directory+'valid/private_keys_wherethewildthingsare.csv'+es }
	# 	let!(:share_1_path) { file_fixtures_directory+'valid/password_share_1_wherethewildthingsare.csv' }
	# 	let!(:share_2_path) { file_fixtures_directory+'valid/password_share_3_wherethewildthingsare.csv' }
	# 	let!(:share_3_path) { file_fixtures_directory+'valid/password_share_5_wherethewildthingsare.csv' }
	# 	before do
	# 		select 3, from: :howmany
	# 	  attach_file "file", encrypted_pkss_path
	# 	  attach_file "password_share_1", share_1_path
	# 	  attach_file "password_share_2", share_2_path
	# 	  attach_file "password_share_3", share_3_path
	# 	  click_button recover_button
	# 	end
	# 	it_should_behave_like 'the private keys page'
	# 	it_should_behave_like 'it does not have download buttons'
	# 	describe "should show the keys correctly" do
	# 		it { should have_selector('td.text_pubkey#address_1', text: '1Hkdv7Ess2pVAU3tZCKpY85TK9tWz9C3qd') }
	# 		it { should have_selector('td.text_prvkey#prvkey_wif_3', text: '5KMEkkPA1hD23HKvttvC33bMuJFxi82KovUrjJ7SZUSgzdAXNTt') }
	# 		it { should have_selector("td#qr_address_2") }
	# 		it { should have_selector("td#qr_prvkey_wif_2") }
	# 		it { should_not have_selector('td.text_pubkey#address_11') }
	# 	end
	# end
	# describe "loading an encrypted private keys csv.enc file with 3 ssss shares using the share file upload interface but not insisting on order or filling" do
	# 	let!(:encrypted_pkss_path) { file_fixtures_directory+'valid/private_keys_wherethewildthingsare.csv'+es }
	# 	let!(:share_1_path) { file_fixtures_directory+'valid/password_share_1_wherethewildthingsare.csv' }
	# 	let!(:share_2_path) { file_fixtures_directory+'valid/password_share_3_wherethewildthingsare.csv' }
	# 	let!(:share_3_path) { file_fixtures_directory+'valid/password_share_5_wherethewildthingsare.csv' }
	# 	before do
	# 		select 5, from: :howmany
	# 	  attach_file "file", encrypted_pkss_path
	# 	  attach_file "password_share_2", share_1_path
	# 	  attach_file "password_share_3", share_2_path
	# 	  attach_file "password_share_5", share_3_path
	# 	  click_button recover_button
	# 	end
	# 	it_should_behave_like 'the private keys page'
	# 	it_should_behave_like 'it does not have download buttons'
	# 	describe "should show the keys correctly" do
	# 		it { should have_selector('td.text_pubkey#address_1', text: '1Hkdv7Ess2pVAU3tZCKpY85TK9tWz9C3qd') }
	# 		it { should have_selector('td.text_prvkey#prvkey_wif_3', text: '5KMEkkPA1hD23HKvttvC33bMuJFxi82KovUrjJ7SZUSgzdAXNTt') }
	# 		it { should have_selector("td#qr_address_2") }
	# 		it { should have_selector("td#qr_prvkey_wif_2") }
	# 		it { should_not have_selector('td.text_pubkey#address_11') }
	# 	end
	# end
	# describe "invalid files" do
	# 	describe "foo.bar" do
	# 		before do
	# 		  attach_file "file", file_fixtures_directory+'invalid/foo.bar'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: upload_format_error) }
	# 	end
	# 	describe "loading an address file with an invalid bitcoin address invalid_address.csv" do
	# 		before do
	# 		  attach_file "file", file_fixtures_directory+'invalid/invalid_address.csv'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }
	# 	end
	# 	describe "loading a file with an invalid addresses format invalid_addresses_format.csv" do
	# 		before do
	# 		  attach_file "file", file_fixtures_directory+'invalid/invalid_addresses_format.csv'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }
	# 	end
	# 	describe "loading an addresses file with an invalid header format invalid_addresses_header.csv" do
	# 		before do
	# 		  attach_file "file", file_fixtures_directory+'invalid/invalid_addresses_header.csv'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }
	# 	end
	# 	describe "loading a private keys file with an invalid_format" do
	# 		before do
	# 		  attach_file "file", file_fixtures_directory+'invalid/invalid_format.csv'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }
	# 	end
	# 	describe "loading a file with an invalid header format invalid_header_format.csv" do
	# 		before do
	# 		  attach_file "file", file_fixtures_directory+'invalid/invalid_header_format.csv'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }
	# 	end
	# 	describe "loading an pkey file with an invalid format invalid_prvkey_format.csv" do
	# 		before do
	# 		  attach_file "file", file_fixtures_directory+'invalid/invalid_prvkey_format.csv'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }
	# 	end
	# 	describe "loading a private keys file with an invalid bitcoin address prkey_with_invalid_address" do
	# 		before do
	# 		  attach_file "file", file_fixtures_directory+'invalid/prkey_with_invalid_address.csv'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }
	# 	end
	# 	describe "loading a prkey_with_non_matching_key_pairs" do
	# 		before do
	# 		  attach_file "file", file_fixtures_directory+'invalid/prkey_with_non_matching_key_pairs.csv'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }
	# 	end
	# 	describe "loading an encrypted private keys file with wrong password" do
	# 		before do
	# 		  attach_file "file", test_encrypted_pk_path
	# 		  fill_in 'password', with: 'foobar'
	# 		  click_button recover_button
	# 		end
	# 		it_should_behave_like 'the inspect page'
	# 		it { page.should have_selector('div.alert.alert-error', text: wrong_password_flash) }
	# 	end
	# end
end
