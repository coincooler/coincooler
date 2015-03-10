require 'spec_helper'
require 'shamir-secret-sharing'

describe "password splitter" do
	# it { PasswordSplitter.should respond_to :join }
	let!(:auto) { PasswordSplitter.new }
	let!(:pass) { '$uperCaliFRagilistic123@fo0' }
	let!(:user) { PasswordSplitter.new(4,3,pass) }
	subject { auto }
	describe "attributes" do
		it { should respond_to :shares }
		it { should respond_to :k }
		it { should respond_to :n }
		it { should respond_to :password }
	end

	describe "default initializer" do	
		its(:k) { should == 3 }
		its(:n) { should == 5 }
		it {auto.password.length.should == 64}
		its(:shares) { should_not be_nil }
		its(:shares) { should be_an_instance_of Array }
	end

	describe "initializer with a password" do		
		subject { user }
		its(:password) { should == pass }
		describe "should have the right attributes" do		
			its(:k) { should == 3 }
			it {user.shares.length.should == 4}
		end
	end

	it "the shares should allow for password retrieval in any combo" do			
		user.shares.combination(3).each do |combo|
			ShamirSecretSharing::Base58.combine(combo).should == pass
		end			
	end		

	describe "k bigger than n" do
		it { expect{PasswordSplitter.new(3,4)}.to raise_error(ArgumentError, 'needed must be <= available') }
	end

end