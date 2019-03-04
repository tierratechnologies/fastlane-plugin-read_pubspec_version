require 'fastlane/action'
require_relative '../helper/read_pubspec_version_helper'

module Fastlane
  module Actions
    module SharedValues
      PUBSPEC_VERSION = :PUBSPEC_VERSION
      PUBSPEC_BUILD = :PUBSPEC_BUILD
    end


    class ReadPubspecVersionAction < Action
      require 'yaml'

      def self.run(params)
        
        # check if path_to_pubspec included in params
        if params[:path_to_pubspec] then
          UI.verbose("pubspec path found in params")
          path = params[:path_to_pubspec]
        else 
          UI.verbose("Try the default pubspec.yaml location")
          path = File.join(File.dirname(__FILE__), '../..', 'pubspec.yaml')   
        end

        UI.verbose("path: #{path} found: #{File.exist?(path)}")
        
        if File.exist?(path) then
          UI.verbose('pubspec.yaml file found')
          
          pubspec_yaml = YAML.load(File.read(path))    
          pubspec_version = pubspec_yaml["version"]

          # check
          version, build = pubspec_version.split('+', 2)

          Actions.lane_context[SharedValues::PUBSPEC_VERSION] = version
          Actions.lane_context[SharedValues::PUBSPEC_BUILD] = build

          puts("")
          puts({'version' => version, 'build' => build})
          puts("")

        else
          UI.error("No pubspec found")
        end

      end

      def self.description
        "read version from pubspec"
      end

      def self.authors
        ["gmcdowell"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
        "Returns a hash with keys 'version' and 'build'"
      end

      def self.return_type 
        :hash
      end
      

      def self.details
        # Optional:
        "as above"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path_to_pubspec,
                                  env_name: "PATH_TO_PUBSPEC_OPTION",
                               description: "An absolute path to the relevant pubspec.yaml file",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
