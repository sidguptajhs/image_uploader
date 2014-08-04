require 'base64'
class Image < ActiveRecord::Base
  attr_accessible :source, :username, :data, :thumb_data
  before_save :save_image
  private
  def save_image
    name=read_attribute(:username)
    data = read_attribute(:source)
    image_data = Base64.decode64(data['data:image/png;base64,'.length .. -1])
    write_attribute(:data,image_data)
    source = Magick::Image.from_blob(image_data).first
    source.resize_to_fit!(320, 240)
    write_attribute(:thumb_data, source.to_blob)
    write_attribute(:source, "nothing")
  end

end
