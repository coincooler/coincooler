require 'spec_helper'

describe "global constants" do
	it { KEYS_LIMIT.class.should == Fixnum }
	it { SHARES_LIMIT.class.should == Fixnum }
	it { DEFAULT_SSSN.class.should == Fixnum }
	it { DEFAULT_SSSK.class.should == Fixnum }
	it { MYENV.class.should == String }
	it { !!PI.should == PI }
	it { !!PROD.should == PI }
	it { !!TEST.should == PI }
	it { !!COPY.should == PI }
	it { !!HOT.should == PI }
	it { PBKDF2_ITERATIONS.class.should == Fixnum }
end