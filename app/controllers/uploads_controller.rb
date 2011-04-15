require 'mime/types'

class UploadsController < ApplicationController
  session :cookie_only => false, :only => :create
  
  
  
  def index
   
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
    
    

    # use RJS here
 
    
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
      render :partial => 'save_text_complete', :locals => {:id => @upload.id}
    else
      flash[:warning] = "Error, Title cannot be changed."
      redirect_to '/'
    end
    
  
  end
  

end
