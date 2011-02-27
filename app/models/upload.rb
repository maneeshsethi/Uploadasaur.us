require 'mime/types'

class Upload < ActiveRecord::Base
  has_attached_file :ufile
  validates_attachment_presence :ufile
  
  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.ufile = data
  end
  
  #return the URL of the file
  def file_link
    return "#{SITE_URL}system/ufiles/#{id}/original/#{ufile_file_name}"
  end
  
end
