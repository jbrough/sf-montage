require 'rmagick'

class Montage
  include Magick

  def self.create(buf1, buf2)
    im = montage(buf1, buf2)
    im.to_blob {
      self.quality = 90
      self.format = "JPEG"
    }
  end

  def self.montage(buf1, buf2)
    c = canvas
    c.composite!(image(buf1), 0, 0, CopyCompositeOp)
    c.composite!(image(buf2), 305, 0, CopyCompositeOp)
    c.composite!(logo, SouthEastGravity, 39, 40, OverCompositeOp)
    c.strip!
    c
  end

  def self.image(buf)
    Image.from_blob(buf)[0].resize_to_fill(295, 600)
  end

  def self.canvas
    Image.new(600, 600) { self.background_color = 'white' }
  end

  def self.logo
    Image.read('./static/logo.png')[0]
  end
end
