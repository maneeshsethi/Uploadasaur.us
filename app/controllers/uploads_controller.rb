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
    
    #bug with .app files, they won't work with swf upload. Also, all files must have an extension.
    if File.extname(params[:Filename]) == "" or File.extname(params[:Filename]) == ".app" 
      return
    end
    
    
    if params[:Filedata]
       @ufile = Upload.create(:swfupload_file => params[:Filedata])
        render :update do |page|

        end
    end
    
  end
  
  def save_title
  
    filename = params['filename']
    
    #if the file was a .app or w/out extension, return.
    if File.extname(filename) == ".app" 
      render :text => "File not uploaded. *.app files cannot be uploaded" and return
    elsif   File.extname(filename) == ""
      render :text => "File not uploaded. File must have an extension." and return
    end
      
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
