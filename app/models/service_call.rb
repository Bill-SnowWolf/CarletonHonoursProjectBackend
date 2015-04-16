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

      # This representative is answering the call      
      call.user.update_attributes(:status => "offline")
    end
    return call
  end

  def self.waiting_count
    calls = ServiceCall.where(:status => 'waiting').order("created_at").length
  end

  # This user is able to pick up a call
  # Find if there is any call waiting
  def self.answer(user_id)
    calls = ServiceCall.where(:status => 'waiting').order("created_at")
    call = calls.first
    if call
      call.status = 'connecting'
      call.user_id = user_id
      call.save

      # This representative is answering the call      
      call.user.update_attributes(:status => "offline")
      
      return call
    else
      return nil
    end
  end
end
