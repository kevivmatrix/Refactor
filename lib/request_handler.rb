class RequestHandler
  attr_accessor :request_data, :socket, :queue

  def initialize(request_data, socket, queue)
    @request_data, @socket, @queue = request_data, socket, queue
  end

  def respond
    self.send("evaluate_#{request_title_downcased}")
  end

  private

  def request_title_downcased
    request_data[0].split.first.downcase
  end

  def evaluate_ping
    socket.send("PONG", 0, request_data[1][3], request_data[1][1])
  end

  def evaluate_send
    request_data[0][5..-1].match(/([a-zA-Z0-9_\-]*) "([^"]*)/)
    json = JSON.generate({
      "registration_ids" => [$1],
      "data" => { "alert" => $2 }
    })
    queue << json
  end

end