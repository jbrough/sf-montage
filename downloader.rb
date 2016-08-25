
class Downloader
  def self.download(url1, url2)
    buf1, err = get(url1)
    return nil, nil, err if err

    buf2, err = get(url2)
    return nil, nil, err if err

    return buf1, buf2, nil
  end

  private

  def self.get(url)
    uri = URI(url)
    res = Net::HTTP.get_response(uri)

    if response_ok?(res)
      return res.body, nil
    else
      return nil, "Bad Download Response"
    end
  end

  def self.response_ok?(response)
    # this implicty checks it's not a 404 etc
    response.response.content_type == "image/jpeg"
  end
end
