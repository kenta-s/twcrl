require "yaml"

module Twcrl
  class RcfileHandler
    def initialize(@config : YAML::Any? = nil)
    end

    def profile
      config["profiles"][screen_name][consumer_key]
    end

    def screen_name : String
      name = config["configuration"]["default_profile"]["screen_name"]
      name.to_s
    end

    def consumer_key : String
      key = config["configuration"]["default_profile"]["consumer_key"]
      key.to_s
    end

    def config
      @config ||= load_file
    end

    def load_oauth
      config["profiles"][screen_name][consumer_key]
    end

    def set_profile(screen_name : String, consumer_key : String, consumer_secret : String, access_token : String, access_token_secret : String)
      yaml =<<-YAML
      #{config.to_yaml}

      profiles:
        #{screen_name}:
          #{consumer_key}:
            screen_name: #{screen_name}
            consumer_key: #{consumer_key}
            consumer_secret: #{consumer_secret}
            access_token: #{access_token}
            access_token_secret: #{access_token_secret}
      YAML
      @config = YAML.parse(yaml)
      save
    end

    def set_default_profile(screen_name : String, consumer_key : String) : Void
      yaml = config["configuration"]["default_profile"].as_h
      yaml["screen_name"] = screen_name
      yaml["consumer_key"] = consumer_key
      save
    end

    def load_file
      if File.exists?(file_path)
        YAML.parse(File.read(file_path))
      else
        yaml =<<-YAML
        ---
        configuration:
          default_profile:
            screen_name: default_screen_name
            consumer_key: default_consumer_key
        YAML
        YAML.parse(yaml)
      end
    end

    def save : Void
      File.write(file_path, config.to_yaml)
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
