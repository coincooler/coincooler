class StaticController < ApplicationController
  
  before_filter :nuke_stale_uploads
  
  def home
  	@title='Home'
  end

  def dieharder
  	send_file dieharder_scorecard, filename: 'dieharder_scorecard.txt', target: '_blank'
  end
end

