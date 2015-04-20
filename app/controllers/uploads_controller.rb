class UploadsController < ApplicationController
  # GET /uploads
  # GET /uploads.json
  # before_filter :set_tag, only: :process
  include InspectorsHelper
  include UploadHelper
  before_filter :clear_pk, only: [:inspect, :keys, :addresses]
  before_filter :clear_stale_uploads
  before_filter :nuke_all_uploads_on_rp, only: :index
  
  def index
    @title=inspect_page_title
    @uploads = Upload.all    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploads.map{|upload| upload.to_jq_upload } }
    end    
  end

  def inspect    
    @title=inspect_page_title
    @shares = get_shares(Upload.all)
    @password = get_password(Upload.all) || params[:password]
    encrypted = Upload.where("upload_file_name LIKE '%"+encrypted_file_suffix+"'")
    @upload = (encrypted[0] unless encrypted.blank?) || Upload.last
    # @upload = Upload.where("upload_file_name LIKE '%"+encrypted_file_suffix+"'")[0] unless @shares.blank?
    if there?(@upload)
      process_uploaded_file(@upload.upload,@password, @shares)
    else
      flash[:error]= {message: missing_file_error, delay_seconds: 5,id: 'missing_file'}
      # redirect_to home_path      
      redirect_to uploads_path
    end    
    # flash[:notice] = "Successfully created..."+@upload.upload_file_name.to_s if @upload
    # render 'index'      
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
    @upload = Upload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/new
  # GET /uploads/new.json
  def new
    @upload = Upload.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/1/edit
  def edit
    @upload = Upload.find(params[:id])
  end

  # POST /uploads
  # POST /uploads.json
  def create
    @upload = Upload.new(upload_params)

    respond_to do |format|
      if @upload.save
        format.html {
          render :json => [@upload.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@upload.to_jq_upload]}, status: :created, location: @upload }        
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /uploads/1
  # PUT /uploads/1.json
  def update
    @upload = Upload.find(params[:id])

    respond_to do |format|
      if @upload.update_attributes(params[:upload])
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to uploads_url }
      format.json { head :no_content }
    end
  end

  def keys
    @expose=params[:expose]
    @title = private_keys_title
    @keys = $keys
    @n=@keys.length
    @remote = (AJAXON && COPY)
    flash.now[:info] = instructions_flash unless @remote
  end

  def addresses
    @expose=params[:expose]   
    @title = addresses_title
    @n=0
    @remote = (AJAXON && COPY)
    @keys = $keys
  end

  def download
    begin
      if COPY
        copy_uploaded_file(params[:download])
      else
        download_uploaded_file
      end
    rescue => e
      logger.warn(e.to_s) 
      flash[:error]= {message: missing_file_error,delay_seconds: 5, id: 'missing_file'}
      redirect_to home_path       
    end
  end

  private

    def upload_params
      params.require(:upload).permit(:upload)
    end
    def instructions_flash
      {message: "You can use the download buttons to download a private key #{'to your USB stick' if usb?}", hide: false,id: 'instruction',close: !COPY} 
    end
    def copy_uploaded_file(addr_or_key)
      if !dynamic_usb_mount
        cookies[:copy] = 'no_usb'
        flash[:danger] = {message: no_usb_message,title: 'Insert a USB drive',delay_seconds: FLASH_DELAY_SECONDS,id: 'no_usb'}
      else
        set_copy_cookie
        file = Upload.last
        origin = file.upload.path
        filename = file.upload_file_name
        target=coldstorage_directory(true)+filename
        FileUtils.mkdir_p File.dirname(target)
        FileUtils.cp(origin,target)
        flash[:success] = {message: "#{filename} "+success_copy_suffix,title: success_copy_title(cold_storage_directory_name),delay_seconds: FLASH_DELAY_SECONDS,id: "download_upload"}
      end
      case addr_or_key
      when 'keys'
        redirect_to old_inspect_keys_path
      when 'addresses'
        redirect_to old_inspect_addresses_path
      end      
    end
    def download_uploaded_file
      file = Upload.last
      filepath = file.upload.path
      filename = file.upload_file_name      
      send_file filepath, filename: filename
    end    
end
