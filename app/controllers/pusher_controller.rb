class PusherController < ApplicationController
    protect_from_forgery except: :auth

  def auth
    response = Pusher['private-test'].authenticate(params[:socket_id])

    render json: response
  end
end
