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
    @keys = $keys
  end

  private

    def upload_params
      params.require(:upload).permit(:upload)
    end
    def instructions_flash
      {message: "You can use the download buttons to download a private key #{'to your USB stick' if usb?}", hide: false,id: 'instruction',close: !COPY} 
    end
end
