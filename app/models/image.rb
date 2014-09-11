class Image < ActiveRecord::Base

 # reverse_geocoded_by :latitude, :longitude
 # after_validation :reverse_geocode, :if => :never_geocoded? # auto-fetch address

 # def never_geocoded? 
 #   new_record? ? true : false
 # end


  has_attached_file :photo, :styles => { :small => "550x550#" },
                    :url  => "/assets/images/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/images/:id/:style/:basename.:extension"

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
end
