require 'hako/script'
require 'aws-sdk-codebuild'

module Hako
  module Scripts
    class CodebuildTag < Script
      class NoSuccessfulBuildError < StandardError; end

      TARGET_TAG = 'codebuild'

      def configure(options)
        super
        @region = options['region']
        @project_name = options.fetch('project', @app.id)
      end

      def deploy_starting(containers)
        app = containers.fetch('app')
        if app.definition['tag'] == TARGET_TAG
          rewrite_tag(app)
        end
      end

      alias_method :oneshot_starting, :deploy_starting

      def codebuild
        @codebuild ||= begin
          options = {}
          options[:region] = @region if @region
          Aws::CodeBuild::Client.new(options)
        end
      end

      private

      def rewrite_tag(app)
        tag = fetch_version
        app.definition['tag'] = tag
        Hako.logger.info("Rewrite tag to #{app.image_tag}")
      end

      def fetch_version
        codebuild.list_builds_for_project(project_name: @project_name, sort_order: 'DESCENDING').each do |page|
          builds = codebuild.batch_get_builds(ids: page.ids).builds.map do |build|
            [build.id, build]
          end.to_h

          page.ids.each do |id|
            build = builds.fetch(id)
            next unless build.build_status == 'SUCCEEDED'
            return build.source_version
          end
        end
        raise NoSuccessfulBuildError
      end
    end
  end
end


