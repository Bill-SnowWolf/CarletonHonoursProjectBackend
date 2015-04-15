class Api::ServiceCallsController < ActionController::Base

  respond_to :json

  # POST /service_calls
  def create
    call = ServiceCall.new
    call.device_token = device_token
    call.status = 'waiting'
    call.save

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

    if available_id
      call.update_attributes(:status => "connecting")

      json = {
        code: "AVAILABLE",
        id: call.id,
        room: available_id
      }
    else
      json = {
        code: "BUSY",
        id: call.id
      }
    end

    render json: json
  end

  # PUT /service_calls/:id
  def update

  end

  private
    def device_token
      params[:device_token]
    end

    def service_call_params
      params[:service_call].permit(:id, :room, :status)
    end
end
