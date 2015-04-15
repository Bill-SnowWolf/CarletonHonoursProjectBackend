class Api::ServiceCallsController < ActionController::Base

  respond_to :json

  # POST /service_calls
  def create
    # Pusher.trigger('presence-lobby', 'my-event', {:message => 'hello world'})
    response = Pusher.get('/channels/presence-lobby/users')
    puts "Response #{response}"

    head :ok
  end

  # private

end
