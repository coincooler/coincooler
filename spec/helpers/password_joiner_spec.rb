require 'spec_helper'
require 'shamir-secret-sharing'

describe "password joiner" do
	let!(:pass) { 'fo0BAA$rbuz!quaax' }
	let!(:splitter) { PasswordSplitter.new(5,3,pass) }
	let!(:joiner) { PasswordJoiner.new(splitter.shares.drop(2)) }
	subject { joiner }
	describe "attributes" do
		it { should respond_to :password }
		its(:password) { should==pass }		
	end
	describe "init with string" do
		it "should raise an error" do
			expect{PasswordJoiner.new('foo')}.to raise_error(RuntimeError)
		end
	end
	describe "empty init" do
		it "should raise an error" do
			expect{PasswordJoiner.new}.to raise_error(ArgumentError, 'wrong number of arguments (0 for 1)')
		end
	end	
	describe "init with number" do
		it "should raise an error" do
			expect{PasswordJoiner.new(1)}.to raise_error(RuntimeError)
		end
	end
	describe "init with fake shares should leave the password nil" do
		it { PasswordJoiner.new([]).password.should be_nil}
		it { PasswordJoiner.new([1]).password.should be_nil}
		it { PasswordJoiner.new([1,2,3]).password.should be_nil}
	end
	it "Joiner should be able to retrieve pass out of any valid combo" do			
		splitter.shares.combination(3).each do |combo|
			PasswordJoiner.new(combo).password.should == pass
		end			
	end	
	it "Joiner should not be able to retrieve from just 2 shares" do			
		splitter.shares.combination(2).each do |combo|
			PasswordJoiner.new(combo).password.should be_nil
		end			
	end
	describe "explicit example of 3 out of 4 shares for 'foo'" do
		let!(:shares_array) { ['3ucnj8eZdNxfSw','C43U2payWYru9F','A9GMe4Dqx4T465','62A4qounESkhdc'] }
		it "should retrieve the password assafassaf from 4 shares" do
			PasswordJoiner.new(shares_array).password.should == 'foo'
		end
		it "should not work with 2 shares" do
			PasswordJoiner.new(shares_array.drop(2)).password.should be_nil
		end
		it "should work with more than 3 valid shares" do
			PasswordJoiner.new(shares_array.drop(1)).password.should == 'foo'
		end		
		it "should not work with an array containing 3 valid shares and other crap" do
			PasswordJoiner.new(shares_array.drop(1)<<'foobar').password.should be_nil
		end	
		it "should not work with an array containing 2 valid and one invalid shares" do
			PasswordJoiner.new(shares_array.drop(2)<<'foobar').password.should be_nil
		end							
	end

	describe "joiner should retrieve splitter random password" do
		let!(:ps) { PasswordSplitter.new }
		it { ps.password.length.should == 64 }
		it { PasswordJoiner.new(ps.shares.drop(2)).should_not be_nil }
		it { PasswordJoiner.new(ps.shares.drop(2)).password.should == ps.password }
	end
	describe "on identical shares" do
		it "should not crash" do
			expect{PasswordJoiner.new(['WfdZ1oqx1xsoRfM4F1mFPsA','WfdZ1oqx1xsoRfM4F1mFPsA','WfdZ1oqx1xsoRfM4F1mFPsA'])}.not_to raise_error
		end
	end
end