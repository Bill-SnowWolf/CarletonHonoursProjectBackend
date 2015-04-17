class PusherController < ApplicationController
  protect_from_forgery except: [:auth, :auth_video]

  def auth
    if params[:id]
      user_id = params[:id]
      user_name = params[:name]
      join_time = params[:time]

      # Each time a representative subscribe to the presence channel
      # We update the status in database, as well as the timestamp
      user = User.find(params[:id])
      user.update_attributes(:status => "online")
    else
      user_id = "Client"
      user_name = "Client"
      join_time = nil
    end

    response = Pusher[params[:channel_name]].authenticate(params[:socket_id],
      user_id: user_id,
      user_info: { 
        name: user_name,
        join_time: join_time
    })

    puts "#{response}"
    render json: response
  end

  def auth_video
    channel = "private-audio-#{params[:room_number]}"

    response = Pusher[channel].authenticate(params[:socket_id])

    render json: response
  end
end
