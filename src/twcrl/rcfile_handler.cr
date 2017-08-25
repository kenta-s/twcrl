require "yaml"

module Twcrl
  class RcfileHandler
    def initialize
      @config = {} of YAML::Type => YAML::Type
      if File.exists?(file_path)
        data = YAML.parse(File.read(file_path))
        @config = data.as_h
      else
        File.touch(file_path)
      end
    end

    def save : Void
      File.write(@file_name, @config.to_yaml)
    end

    def file_path : String
      File.join(directory, ".twcrlrc")
    end

    def directory : String
      @directory ||= File.expand_path("~")
    end

    def directory=(dir : String) : Void
      @directory = dir
    end
  end
end
