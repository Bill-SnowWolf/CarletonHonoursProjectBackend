class ServiceCall < ActiveRecord::Base
  belongs_to :user

  def self.new_call(token, available_user_id) 
    call = ServiceCall.new
    call.device_token = token
    call.status = 'waiting'
    call.save

    if available_user_id
      call.status = "connecting"
      call.user_id = available_user_id
      call.save
    end
    return call
  end

end
