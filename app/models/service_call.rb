class ServiceCall < ActiveRecord::Base
  belongs_to :user

  def self.new_call(token, customer_data, available_user_id) 
    call = ServiceCall.new
    call.device_token = token
    call.status = 'waiting'
    call.name = customer_data[:name]
    call.email = customer_data[:email]
    call.phone = customer_data[:phone]
    call.save

    if available_user_id
      call.status = "connecting"
      call.user_id = available_user_id
      call.save

      # This representative is answering the call      
      call.user.update_attributes(:status => "connecting")

      call.user.delay_check_call_status(self)
    end
    return call
  end

  def self.waiting_count
    calls = ServiceCall.where(:status => 'waiting').order("created_at").length
  end

end
