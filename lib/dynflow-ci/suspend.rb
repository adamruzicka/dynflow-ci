module DynflowCI
  class Suspend < Base
    def run(event = nil)
      if event.nil?
        log "#{Time.now}: going to sleep"
      plan_event(:wake_up, 10)
      suspend
    elsif event == :wake_up
      log "#{Time.now}: waking up"
      end
    end
  end
end
