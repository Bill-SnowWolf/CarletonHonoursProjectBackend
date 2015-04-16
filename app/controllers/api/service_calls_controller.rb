class Api::ServiceCallsController < ActionController::Base
  respond_to :json

  before_action :set_service_call, only: [:update]

  # POST /service_calls
  def create
    response = Pusher.get('/channels/presence-lobby/users')
    puts "Response #{response[:users]}"

    available_id = nil
    response[:users].each do |user|
      if (user["id"] != "Client")
        available_id = user["id"]
        break
      end
    end

    call = ServiceCall.new_call(device_token, available_id)

    if call.user_id
      json = {
        code: "AVAILABLE",
        id: call.id,
        room: call.user_id
      }
    else
      json = {
        code: "BUSY",
        id: call.id,
        waiting_count: ServiceCall.waiting_count
      }
    end

    render json: json
  end

  # PUT /service_calls/:id
  def update
    puts "params: #{service_call_params}"
    @service_call.update_attributes(:status => service_call_params[:status])

    head :ok
  end

  # POST /service_calls/available_user
  def available_user
    call = ServiceCall.answer(user_id)
    if call
      json = {
        code: "USER_AVAILABLE",
        room: call.user_id
      }
      APNS.send_notification(call.device_token, 
                             :alert => 'Representative Available! Please Confirm...', 
                             :sound => 'default',
                             :other => json)
    end

    head :ok
  end

  private
    def device_token
      params[:device_token]
    end

    def service_call_params
      params[:service_call].permit(:id, :room, :status)
    end

    def set_service_call
      @service_call = ServiceCall.find(params[:id])
    end

    def user_id
      params[:user_id]
    end
end
