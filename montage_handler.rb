require 'rack'
require_relative 'downloader'
require_relative 'montage'

class MontageHandler
  def call(env)
    req = Rack::Request.new(env)
    urls = [req.params['l'], req.params['r']]
    buf1, buf2, err = Downloader.download(urls)
    buf, err = Montage.create(buf1, buf2)

    headers = { 'Content-Type' => 'image/jpeg' }
    [200, headers, [buf]]
  end
end
