require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FilesHelper
describe "Static" do
	subject { page }

  describe "App Home page" do
    before { visit home_path }
    it_should_behave_like "app pages"
    it { should have_title full_title(home_title) }
    it { should have_selector('div#catchy', text: catch_phrase_big) }
    it { should have_selector('div#elevator', text: elevator_pitch) }
    it { should have_xpath("//a[@class='btn btn-primary btn-large'][@title='#{big_freeze_button_title}'][@id='big_freeze_button']")}
    it { should have_xpath("//a[@class='btn btn-success btn-large'][@title='#{big_inspect_button_title}'][@id='big_inspect_button']")}    
    describe "big freeze button takes you to the freeze page" do
      before { find('#big_freeze_button',visible: true).click}
      it { page.current_path.should == freeze_path }
    end
    describe "big inspect button should take you to the inspect page" do
      before { find('#big_inspect_button',visible: true).click }
      it { page.current_path.should == uploads_path }
    end
  end

 
end 