module DynflowCI
  class RunCommand < Base
    def run
      Dir.chdir(input[:path]) do
        raise "Command failed" unless system(input[:command])
      end
    end
  end
end
