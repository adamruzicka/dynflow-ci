require 'dynflow-ci/systemd_helper'

module DynflowCI
  class Polling < Base
    include ::Dynflow::Action::Polling

    def invoke_external_task
      output[:service] = SystemdHelper.start input[:cmd]
      poll_external_task
    end

    def poll_external_task
      output[:log] = SystemdHelper.log output[:service]
      SystemdHelper.show output[:service]
    end

    def done?
      !SystemdHelper.running? self.external_task
    end

    def on_finish
      SystemdHelper.stop output[:service]
      error! "The execution failed" unless SystemdHelper.exitcode(self.external_task).zero?
    end
  end
end
