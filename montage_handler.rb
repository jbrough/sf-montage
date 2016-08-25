require 'rack'
require_relative 'downloader'
require_relative 'montage'

class MontageHandler
  def call(env)
    req = Rack::Request.new(env)
    url1, url2 = req.params['l'], req.params['r']
    buf1, buf2, err = Downloader.download(url1, url2)
    return [500, {}, [err]] if err

    buf, err = Montage.create(buf1, buf2)
    return [500, {}, [err]] if err

    headers = { 'Content-Type' => 'image/jpeg' }
    [200, headers, [buf]]
  end
end
