class ProjectAsset
  include Mongoid::Document

  attr_accessor :crop_x, :crop_y, :crop_h, :crop_w
  #after_update :reprocess_profile, :if => :cropping?
  
  field :name
  
  mount_uploader :attachment, ProfileUploader

  def cropping?
    !crop_x.blank? and !crop_y.blank? and !crop_h.blank? and !crop_w.blank?
  end

  def profile_geometry
    db   = Mongo::Connection.new.db('image_crop_development')
    puts self.attachment.url(:large), "pathhhhhhhhhhhhhhhhhhhhhhhhh"
    img = MiniMagick::Image.read(Mongo::GridFileSystem.new(db).open(self.attachment.url(:large), 'r'))
    #img = MiniMagick::Image.open(@image)
    @geometry = {:width => img[:width], :height => img[:height] }
  end

  private

  def reprocess_profile
    #img = MiniMagick::Image.open(self.attachment.large.path)
    db   = Mongo::Connection.new.db('image_crop_development')

    img ||= MiniMagick::Image.read(Mongo::GridFileSystem.new(db).open(self.attachment.url(:large), 'r'))
    crop_params = "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"
    img.crop(crop_params)
    img.write("/home/raman/test.jpeg")
    attachment.recreate_versions!
  end
end
