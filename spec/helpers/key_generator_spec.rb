require 'spec_helper'

describe "key generator" do
	let!(:keygen) { KeyGenerator.new(2) }
	subject { keygen }
	describe "attributes" do
		it { should respond_to :keys }
		it { should respond_to :howmany }
	end

	describe "initializer" do
		it { keygen.keys.class.should == Array }
		it { keygen.keys.length.should == keygen.howmany }
		its(:howmany) { should == 2 }
	end

	describe "empty initializer" do
	 	it {expect {KeyGenerator.new }.to raise_error(ArgumentError,/wrong number of arguments/)}
	end

	describe "must be initialized with a positive integer" do
 		it {expect {KeyGenerator.new(1) }.not_to raise_error('must initialize with a positive integer')}
		it {expect {KeyGenerator.new(-1) }.to raise_error('must initialize with a positive integer')}
		it {expect {KeyGenerator.new('foo') }.to raise_error('must initialize with a positive integer')}
		it {expect {KeyGenerator.new('') }.to raise_error('must initialize with a positive integer')}
		it {expect {KeyGenerator.new(nil) }.to raise_error('must initialize with a positive integer')}
	end

	describe "each entry is a bitcoin key object" do
		specify {keygen.keys[0].class.should == Bitcoin::Key }
	end


end
