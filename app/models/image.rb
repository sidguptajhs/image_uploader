require 'base64'
class Image < ActiveRecord::Base
  attr_accessible :source, :username
  before_save :save_image
  private
  def save_image
    name=read_attribute(:username)
    data = self.read_attribute(:source)
    image_data = Base64.decode64(data['data:image/png;base64,'.length .. -1])
    File.open("#{RAILS_ROOT}/public/#{name}.png", 'wb') do |f|
      f.write image_data
    end
    img = Magick::Image.read("#{RAILS_ROOT}/public/#{name}.png").first
    target = Magick::Image.new(320, 240) do
      self.background_color = 'white'
    end
    img.resize_to_fit!(320, 240)
    target.composite(img, Magick::CenterGravity, Magick::CopyCompositeOp).write("#{Rails.root}/public/small-#{name}.png")
    write_attribute(:source,name+".png")
  end
end
