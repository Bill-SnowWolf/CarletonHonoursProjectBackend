class PusherController < ApplicationController
    protect_from_forgery except: [:auth, :auth_video]

  def auth
    if params[:id]
      user_id = params[:id]
      user_name = params[:name]
    else
      user_id = "Client"
      user_name = "Client"
    end

    response = Pusher[params[:channel_name]].authenticate(params[:socket_id],
      user_id: user_id,
      user_info: { name: user_name })

    puts "#{response}"
    render json: response
  end

  def auth_video
    channel = "private-video-#{params[:room_number]}"

    response = Pusher[channel].authenticate(params[:socket_id])

    render json: response
  end
end
