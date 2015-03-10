class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ViewsHelper
  include CryptoHelper
  include QrHelper
  include FreezersHelper  
  include FilesHelper
  include DataHelper
  include CacheHelper
  # include InspectorsHelper

end
