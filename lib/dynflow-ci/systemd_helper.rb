module DynflowCI
  class SystemdHelper
    class << self

      KEYS = %w(SubState ExecMainStatus)

      def start(cmd)
        script = <<EOF
#!/bin/zsh
source ~/.zshrc
eval "$(rbenv init -)"
#{cmd}
EOF
        File.write('runme.sh', script)
        _, err = Open3.capture3("systemd-run --user --remain-after-exit -p WorkingDirectory=#{Dir.getwd} /bin/zsh -l #{Dir.getwd}/runme.sh")
        /(run-.*\.service)/.match(err)[1]
      end

      def stop(job)
        `systemctl --user reset--failed #{job}`
        `systemctl --user stop #{job}`
      end

      def show(job)
        `systemctl show --user #{job}`.lines.reduce({}) do |acc, cur|
          if KEYS.any? { |key| cur.start_with? key }
            key, value = cur.split('=')
            acc.merge(key => value.chomp)
          else
            acc
          end
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
