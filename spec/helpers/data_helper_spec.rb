require 'spec_helper'

include CryptoHelper
include FilesHelper

describe DataHelper do

	describe "build_addresses_hash_array_from_csv" do
		let!(:addr_csv) { [["#", "Bitcoin Address"], ["1", "18KVUSLdn984nnf5DwBUEPFdUc6Ca2UErh"], ["2", "1Jhf5sVmuVDVh23UZFaVW267cMWYCCJxEG"]] }
		let!(:addr_hash) { build_addresses_hash_array(addr_csv) }
		subject { addr_hash }
		its(:length) { should == 2 }
		it { addr_hash[0][:addr].should == '18KVUSLdn984nnf5DwBUEPFdUc6Ca2UErh' }
		it { addr_hash[1][:addr].should == '1Jhf5sVmuVDVh23UZFaVW267cMWYCCJxEG' }
	end

	describe "build_private_keys_hash_array_from_csv" do
		let!(:pk_csv) { [["#", "Bitcoin Address", "Private Key"], ["1", "12fNHfnk1DvdMjrBbzjFd5WhEQWm68xM4K", "5J2PLz9ej2k7c1UEfQANfQgLsZnFVeY5HjZpnDe1n6QSKXy1zFQ"], ["2",  "1LTRtjXoU5pCgTDBMdFMKepuFRHB1Jan2Y",  "5KSfstJGVjkkpWm9Yi1aW2qbPg17KNxtKYQXeDfGwEYNcKZbRsV"]] }
		let!(:pk_hash) { build_private_keys_hash_array(pk_csv) }
		subject { pk_hash }
		its(:length) { should == 2 }
		it { pk_hash[0][:private_wif].should == '5J2PLz9ej2k7c1UEfQANfQgLsZnFVeY5HjZpnDe1n6QSKXy1zFQ' }
		it { pk_hash[1][:private_wif].should == '5KSfstJGVjkkpWm9Yi1aW2qbPg17KNxtKYQXeDfGwEYNcKZbRsV' }
		it { pk_hash[0][:addr].should == '12fNHfnk1DvdMjrBbzjFd5WhEQWm68xM4K' }
		it { pk_hash[1][:addr].should == '1LTRtjXoU5pCgTDBMdFMKepuFRHB1Jan2Y' }
	end	
 

end