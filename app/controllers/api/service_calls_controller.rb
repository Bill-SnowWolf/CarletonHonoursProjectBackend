class Api::ServiceCallsController < ActionController::Base

  respond_to :json

  # POST /service_calls
  def create
    # Pusher.trigger('presence-lobby', 'my-event', {:message => 'hello world'})
    response = Pusher.get('/channels/presence-lobby/users')
    puts "Response #{response[:users]}"

    available_id = nil
    response[:users].each do |user|
      if (user["id"] != "Client")
        available_id = user["id"]
        break
      end
    end

    puts "Available: #{available_id}"

    if available_id
      json = {
        code: "AVAILABLE",
        id: available_id
      }
    else
      json = {
        code: "BUSY"
      }
    end

    render json: json
  end

  # private

end
