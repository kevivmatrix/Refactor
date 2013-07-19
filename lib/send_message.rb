require "bundler"
Bundler.setup

require "json"
require "thread"
require "httpclient"
require "socket"

queue = Queue.new
client = HTTPClient.new
socket = UDPSocket.new

require "request_handler.rb"

10.times do
  Thread.new do
    while data = queue.pop
      client.post("https://android.googleapis.com/gcm/send", data, {
        "Authorization" => "key=AIzaSyCABSTd47XeIH",
        "Content-Type" => "application/json"
      })
    end
  end
end

socket.bind("0.0.0.0", 6889)

while request_data = socket.recvfrom(4096)
  RequestHandler.new(request_data, socket, queue).respond
end