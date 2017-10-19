module Fastlane
  module Actions
    class UploadDsymAction < Action

      # Given a dsym zip path, a Rollbar access token,
      # an app bundle identifier and an app version
      # uploads the given dsym to Rollbar with
      # the provided configuration.
      # Returns if the upload was successful.

      def self.run(params)
        # Uploads the zipped dsym file to Rollbar.

      response = %x<curl -X POST "https://api.rollbar.com/api/1/dsym" \
          -F access_token=#{params[:access_token]} \
          -F version=#{params[:version]} \
          -F bundle_identifier=#{params[:bundle_identifier]} \
          -F dsym=@"#{params[:dsym_zip_path]}">

        # If upload was successful "error" is 0.
        # https://rollbar.com/docs/api/items_post/
        not JSON.parse(response)["err"].zero?
          UI.error("Error uploading DSYM file: #{JSON.parse(response)["message"]}")

      end

      # Fastlane Action class required functions.

      def self.is_supported?(platform)
        true
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :access_token, optional: false),
          FastlaneCore::ConfigItem.new(key: :version, optional: false),
          FastlaneCore::ConfigItem.new(key: :bundle_identifier, optional: false),
          FastlaneCore::ConfigItem.new(key: :dsym_zip_path, optional: false),
        ]
      end

    end
  end
end
