require "yaml"

module Twcrl
  class RcfileBuilder
    YAML.mapping(
      profiles: YAML::Any?,
      configuration: YAML::Any?,
    )
  end

  class RcfileHandler
    def initialize
      # @config = {} of YAML::Type => YAML::Type
      # @config = load_file
    end

    def load_file
      if File.exists?(file_path)
        RcfileBuilder.from_yaml(File.read(file_path))
      else
        yaml =<<-YAML
        ---
        profiles:
          default_name:
            default_consumer_key:
        configuration:
          default_profile:
          - default_name
          - default_consumer_key
        YAML
        RcfileBuilder.from_yaml(yaml)
      end
    end

    def save : Void
      File.write(@file_name, config.to_yaml)
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
