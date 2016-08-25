require 'logger'
require 'em-http-request'

class Downloader
  def self.download(urls)
    bufs = []
    err = nil

    log = Logger.new(STDERR)

    EM.run do
      multi = EM::MultiRequest.new

      multi.add(:l, EM::HttpRequest.new(urls[0]).get)
      multi.add(:r, EM::HttpRequest.new(urls[1]).get)

      multi.callback do
        if !err = check_err(multi.responses)
          bufs = get_bufs(multi.responses)
        end

        err ||= "Missing buffer" if bufs.length < 2
        EM.stop
      end
    end

    if err
      return nil, nil, err
    end

    return bufs[0], bufs[1], err
	end

  private

  def self.check_err(responses)
    errs = responses[:errback]
    err = errs[:l] || errs[:r]
    if err
      return err.error
    end
  end

  def self.get_bufs(responses)
    [:l, :r].map do |k|
      r = responses[:callback][k]
      response_ok?(r) ? r.response : nil
    end.compact
  end

  def self.response_ok?(response)
    # this implicty checks it's not a 404 etc
    response.response_header["CONTENT_TYPE"] == "image/jpeg"
  end
end
