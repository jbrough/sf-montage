require 'rack'

require_relative 'montage_handler'

map '/montage' do
  run MontageHandler.new
end
