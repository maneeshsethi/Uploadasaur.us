require 'mime/types'

class UploadsController < ApplicationController
  session :cookie_only => false, :only => :create
  
  
  def index
    logger.debug "in index"
    # if something was submitted
    if params[:File]
      logger.debug "\ngsdfsdfgd"
      logger.debug (swf_uploaded_data)
      @ufile = Upload.create(:ufile => swf_upload_data) # here you can use your favourite plugin to work with attachments
      
      
      # use RJS here
      render :update do |page|
        page['blocks'].insert("<div><img src=\"http://domain.com\" /></div>")
      end

    else
      
      
    end
    
    
    #if params[:upload] != ''
    #  @upload = Upload.create(params[:upload])
    #end
  end

  def create
    
    # SWFUpload file
    if params[:Filedata]
      @ufile = Upload.new(:swfupload_file => params[:Filedata]) # here you can use your favourite plugin to work with attachments
      @results = @ufile.save
      logger.debug("ajx @#{@results} ")
      if @ufile.save
        render :update do |page|
           page['blocks'].insert("<div><img src=\"http://domain.com\" /></div>")
         end
      else
        render :text => "error"
      end
    else
      # Standard upload
      @photo = Photo.new params[:photo]
      if @photo.save
        flash[:notice] = 'Your photo has been uploaded!'
        redirect_to photos_path
      else
        render :action => :new
      end
    end
    
    

    # use RJS here
 
    
  end

end
