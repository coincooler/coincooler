require 'spec_helper'
include PathHelper

describe FilesHelper do
	let!(:header) { ['c1','c2'] }
	let!(:data) { [['11','12'],['21','22']] }
	let!(:path) { file_fixtures_directory + 'csvtest.csv' }
	let!(:epath) { file_fixtures_directory + 'ecsvtest.csv' }
	it {expect {save_csv(path,header,data)}.not_to raise_error}
	it {expect {save_enum_csv(epath,header,data)}.not_to raise_error}

	describe "save_csv" do
		before do
			save_csv(path,header,data)
		end
		describe "csv file should be correct" do
			let!(:file) { CSV.read(path) }
			subject { file }
			it { should ==  [["c1", "c2"], ["11", "12"], ["21", "22"]] }
		end
		after do
			delete_file(path)
		end
	end
	describe "save simple csv" do
		before do
			save_csv(path,['foo'],[['bar']])
		end
		describe "csv file should be correct" do
			let!(:file) { CSV.read(path) }
			subject { file }
			it { should ==  [['foo'], ['bar']] }
		end
		after do
			delete_file(path)
		end
	end	
	describe "save_enum_csv" do
		before do
			save_enum_csv(epath,header,data)
		end
		describe "csv file should be correct" do
			let!(:efile) { CSV.read(epath) }
			subject { efile }
			it { should ==  [["#","c1", "c2"], ["1","11", "12"], ["2","21", "22"]] }
		end
		after do
			delete_file(epath)
		end
	end

	describe "addresses_csv_format" do
		let!(:foo) { CSV.read(file_fixtures_directory+'invalid/foo.bar') }
		let!(:test_pa_path) { file_fixtures_directory+'valid/'+addresses_file_name+'.csv' }
		let!(:good_file) { CSV.read(test_pa_path) }
		it {addresses_csv_format?(good_file).should be_true}
		['foo.bar','invalid_address.csv','invalid_addresses_format.csv','invalid_addresses_header.csv','invalid_format.csv','invalid_header_format.csv'].each do |example|
			it {addresses_csv_format?(CSV.read(file_fixtures_directory+'invalid/'+example)).should be_false}	
		end	
	end

	describe "private_keys_csv_format" do
		let!(:foo) { CSV.read(file_fixtures_directory+'invalid/foo.bar') }
		let!(:test_pk_path) { file_fixtures_directory+'valid/'+private_keys_file_name+'.csv' }
		let!(:good_file) { CSV.read(test_pk_path)}
		it {private_keys_csv_format?(good_file).should be_true}
		['foo.bar','invalid_address.csv','invalid_addresses_format.csv','invalid_addresses_header.csv','invalid_format.csv','invalid_header_format.csv','invalid_prvkey_format.csv','prkey_with_invalid_address.csv','prkey_with_non_matching_key_pairs.csv'].each do |example|
			it {private_keys_csv_format?(CSV.read(file_fixtures_directory+'invalid/'+example)).should be_false} 
		end		
	end

	describe "unless_usb" do
		it { unless_usb(true,'foo').should be_blank }
		it { unless_usb(false,'bar').should == 'bar' }
	end
end