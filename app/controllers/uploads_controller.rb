require 'mime/types'

class UploadsController < ApplicationController
  session :cookie_only => false, :only => :create
  
  
  
  def index

    #refresh due to TamperWithCookie exception on first session call http://groups.google.com/group/rubyonrails-talk/browse_thread/thread/ad918b9f59a017bc
      if cookies[:refreshed] != 'true'
        cookies[:refreshed] = 'true'
        layout_to_render = 'refresh'
      else
        layout_to_render = 'default'
      end

    if layout_to_render == 'refresh'
      render :layout => 'refresh'
    else
      render :layout => 'default'
    end
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
    title = params['title'].strip
    @upload = Upload.find(:first, :order => '`created_at` DESC', :conditions => ["ufile_file_name = ? and ufile_file_size = ?", filename, filesize])
    if @upload
      @upload.title = title
      @upload.save
      render :partial => 'file_link', :locals => {:link_url => @upload.file_link, :title => @upload.title, :id => @upload.id}
    else
      render :text => 'File not uploaded. Please try again.'
    end
  end
  
  def change_title
    @upload = Upload.find(params[:id])
    
    if @upload
      @upload.title = params[:title]
      @upload.save
      render :partial => 'save_text_complete', :locals => {:title => @upload.title, :id => @upload.id}
    else
      flash[:warning] = "Error, Title cannot be changed."
      redirect_to '/'
    end
    
  
  end
  

end
