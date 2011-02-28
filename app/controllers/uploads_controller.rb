require 'mime/types'

class UploadsController < ApplicationController
  session :cookie_only => false, :only => :create
  
  
  def index
    # if something was submitted
    if params[:File]
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
        render :text => params[:Filedata].inspect
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
  
  def save_title
  
    filename = params['filename']
    filesize = params['filesize']
    fileprogress_id = params['fileprogress_id']
    title = params['title']
    @upload = Upload.find(:first, :order => '`created_at` DESC', :conditions => ["ufile_file_name = ? and ufile_file_size = ?", filename, filesize])
    if @upload
      @upload.title = title
      @upload.save
      render :partial => 'file_link', :locals => {:link_url => @upload.file_link, :title => @upload.title, :id => @upload.id}
    else
      render :text => 'error'
    end
  end
  

end
