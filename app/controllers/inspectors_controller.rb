class InspectorsController < ApplicationController
  include InspectorsHelper

  before_filter :clear_pk, only: [:show, :addresses]
  before_filter :redirect_on_refresh, only: [:addresses, :private_keys]
  before_filter :set_tag, only: :create

  def new
  	@title=inspect_page_title
  end

  def create
    @title=inspect_page_title
    # set_tag
    uploaded_shares=''
    (1..SHARES_LIMIT).each do |share_number|
      share_file_meta=params["password_share_#{share_number.to_s}"]
      uploaded_shares << CSV.read(share_file_meta.path)[1][0]+" " unless share_file_meta.blank?
    end
    if params[:file].blank?
      flash.now[:error] = no_file_loaded_flash
      render 'new'
    elsif uploaded_shares.blank?
      process_uploaded_file(params[:file],params[:password].strip,params[:shares])
    else
      process_uploaded_file(params[:file],params[:password].strip,uploaded_shares)
    end
  end

  def show
    @expose=params[:expose]
    @title = private_keys_title
    @keys = $keys
    @n=@keys.length
    @remote = (AJAXON && COPY)
  end

  def addresses
    @expose=params[:expose]
  	@title = addresses_title
  	@keys = $keys
  end

  def download
    begin
      if COPY
        copy_row(params[:download].to_i)
      else
        download_row(params[:download].to_i)
      end
    rescue => e
      logger.warn(e.to_s)
      flash[:error]= {message: missing_file_error,delay_seconds: 5, id: 'missing_file'}
      redirect_to home_path
    end
  end

  private
    def copy_row(number)
      unless usb_attached?
        cookies[:copy] = 'no_usb'
        flash[:danger] = {message: no_usb_message,title: 'Insert a USB drive',delay_seconds: FLASH_DELAY_SECONDS,id: 'no_usb'}
      else
        set_copy_cookie
        FileUtils.mkdir_p unencrypted_directory_path(true)
        save_csv_for_row(number,download_row_file_path(number, true))
        flash[:success] = {message: "row number #{number} "+success_copy_suffix,title: success_copy_title(cold_storage_directory_name),delay_seconds: FLASH_DELAY_SECONDS,id: "download_row_#{number}"}
      end
      redirect_to old_inspect_keys_path
    end
    def download_row(number)
      path=download_row_file_path(number)
      save_csv_for_row(number,path)
      send_file path, filename: download_row_file_name+"_#{number}.csv"
    end
end
