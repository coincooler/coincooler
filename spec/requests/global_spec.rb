require 'spec_helper'

describe "global constants" do
	it { KEYS_LIMIT.class.should == Integer }
	it { SHARES_LIMIT.class.should == Integer }
	it { DEFAULT_SSSN.class.should == Integer }
	it { DEFAULT_SSSK.class.should == Integer }
	it { !!PI.should == PI }
	it { !!PROD.should == PI }
	it { !!TEST.should == PI }
	it { !!COPY.should == PI }
	it { !!HOT.should == PI }
	it { PBKDF2_ITERATIONS.class.should == Integer }
end
