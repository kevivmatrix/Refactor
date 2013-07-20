require "bundler"
Bundler.setup

require "json"
require "thread"
require "httpclient"
require "socket"

require "message_poper.rb"
require "request_handler.rb"

queue = Queue.new
client = HTTPClient.new
message_poper = MessagePoper.new(client, queue)
socket = UDPSocket.new

10.times do
  Thread.new do
    message_poper.listen
  end
end

socket.bind("0.0.0.0", 6889)

while request_data = socket.recvfrom(4096)
  RequestHandler.new(request_data, socket, queue).respond
end