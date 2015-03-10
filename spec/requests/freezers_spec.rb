require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end

describe "Freezers:" do
	subject { page }
	before do
	  visit freeze_path
	end
	it_should_behave_like 'the freeze page'
end
