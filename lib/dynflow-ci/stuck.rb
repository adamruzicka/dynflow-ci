module DynflowCI
  class Stuck < Base
    include ::Dynflow::Action::Cancellable

    def run(event = nil)
      output[:log] ||= []
      if event.nil?
        output[:log] << "#{Time.now}: Suspending"
        suspend
      else
        super
      end
    end

    def cancel!
      output[:log] << "#{Time.now}: Cancelled by user"
      raise "Cancelled by user"
    end
  end
end
