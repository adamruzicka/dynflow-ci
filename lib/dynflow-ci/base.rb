require 'open3'

module DynflowCI
  class Base < ::Dynflow::Action
    def log(msg)
      output[:log] ||= []
      msg = [msg] unless msg.kind_of? Array
      msg.each { |m| output[:log] << m }
    end

    def run_command(cmd)
      log "Running command #{cmd}"
      out, err, status = Open3.capture3(cmd)

      log(lines(out))
      log(lines(err))
      log "Command exit status: #{status.exitstatus}"
      raise "Command failed" unless status.exitstatus.zero?
    end

    private

    def lines(output)
      output.lines.map(&:chomp)
    end
  end
end
