module DynflowCI
  class SystemdHelper
    class << self
      def start(cmd)
        _, err = Open3.capture3("systemd-run --user --remain-after-exit -p WorkingDirectory=#{Dir.getwd} #{cmd}")
        /(run-.*\.service)/.match(err)[1]
      end

      def status(job)
        show(job)["SubState"]
      end

      def output(job)
        `journalctl --user-unit #{job}`
      end

      def running?(job)
        status(job) == 'running'
      end

      def exitcode(job)
        show(job)["ExecMainStatus"].to_i
      end

      def stop(job)
        `systemctl --user stop #{job}`
      end

      def log(job)
        `journalctl --user-unit #{job}`.lines.map(&:chomp)
      end

      private

      def show(job)
        `systemctl show --user #{job}`.lines.reduce({}) do |acc, cur|
          key, value = cur.split('=')
          acc.merge(key => value.chomp)
        end
      end
    end
  end
end
