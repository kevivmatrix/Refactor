class MessagePoper

  attr_accessor :client, :queue

  def initialize(client, queue)
    @client, @queue = client, queue
  end

  def listen
    while data = queue.pop
      publish(data)
    end
  end

  private

  def publish(data)
    client.post(send_url, data, {
      "Authorization" => "key=AIzaSyCABSTd47XeIH",
      "Content-Type" => "application/json"
    })
  end

  def send_url
    "https://android.googleapis.com/gcm/send"
  end

end