module DynflowCI
  class SystemdHelper
    class << self
      def start(cmd)
        File.write('runme.sh', cmd)
        _, err = Open3.capture3("systemd-run --user --remain-after-exit -p WorkingDirectory=#{Dir.getwd} /bin/sh #{Dir.getwd}/runme.sh")
        /(run-.*\.service)/.match(err)[1]
      end

      def stop(job)
        `systemctl --user reset--failed #{job}`
        `systemctl --user stop #{job}`
      end

      def show(job)
        `systemctl show --user #{job}`.lines.reduce({}) do |acc, cur|
          key, value = cur.split('=')
          acc.merge(key => value.chomp)
        end
      end

      def log(job)
        `journalctl --user-unit #{job}`.lines.map(&:chomp)
      end

      def status(hash)
        hash["SubState"]
      end

      def running?(hash)
        status(hash) == 'running'
      end

      def exitcode(hash)
        hash["ExecMainStatus"].to_i
      end
    end
  end
end
