class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :service_calls  

  # This user is able to pick up a call
  # Find if there is any call waiting
  def answer_call
    call = ServiceCall.where(:status => 'waiting').order("updated_at").first
    # call = calls.first
    if call
      call.status = 'connecting'
      call.user = self
      call.save

      # This representative is answering the call      
      self.update_attributes(:status => "connecting")
      self.delay_check_call_status(call)
      
      Pusher.trigger("private-audio-#{self.id}", 'client-connecting', nil)
      return call
    else
      return nil
    end
  end

  def delay_check_call_status(call)
    self.delay(run_at: 15.seconds.from_now).check_call_status(call)
  end

  def check_call_status(call)    
    if call.status == "connecting"
      # No response or there is error during signalling      
      if call.attempt_count < 5        
        call.status = 'waiting'
        call.attempt_count += 1
        call.user = nil
        call.save
      else
        call.status = 'discarded'
        call.save
      end

      self.status = 'offline'
      Pusher.trigger("private-audio-#{self.id}", 'client-reset', self.id)
    end
  end

end
