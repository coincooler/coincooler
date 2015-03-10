require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper


describe "layout" do
	before { visit home_path }
	subject { page }
	describe "logo link" do
		before { click_link app_title}
		it { page.current_path.should == home_path }
	end
	describe "freeze link should show freeze page" do
		before { find('#big_freeze_button',:visible => true).click }
		it_should_behave_like 'app pages'
		it_should_behave_like "the freeze page"
	end
	describe "inspect link should show inspect page" do
		before { find('#big_inspect_button',:visible => true).click }
		it_should_behave_like 'app pages'
		it_should_behave_like "the uploads page"
	end		
end