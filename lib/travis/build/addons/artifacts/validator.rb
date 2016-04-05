module Travis
  module Build
    class Addons
      class Artifacts < Base
        class Validator
          MSGS = {
            pull_request: 'Artifacts support disabled for pull requests',
            branch_disabled: 'Artifacts support disabled: the current branch is not enabled as per configuration (%s)'
          }

          attr_reader :data, :config, :errors

          def initialize(data, config)
            @data = data.tap {|d| puts "data.branch: #{d.branch}\ndata.pull_request?: #{d.pull_request}"}
            @config = config.tap {|cfg| puts "config 1: #{cfg}"}
            @errors = []
            puts "@config: #{@config}"
          end

          def valid?
            validate
            errors.empty?
          end

          private

            def validate
              puts "config 2: #{config}"
              [:push_request, :branch].each do |name|
                send(:"validate_#{name}")
              end
            end

            def validate_push_request
              error :pull_request if pull_request?
            end

            def validate_branch
              error :branch_disabled, data.branch unless branch_runnable?
            end

            def pull_request?
              data.pull_request
            end

            def branch_runnable?
              no_branch_configured? || branch_enabled?
            end

            def no_branch_configured?
              branch.nil?.tap {|x| puts "#{__method__} #{x}"}
            end

            def branch_enabled?
              [branch].flatten.include?(data.branch).tap {|x| puts "#{__method__} #{x}"}
            end

            def branch
              puts "config 3: #{config}"
              config[:branch].tap {|x| puts "#{__method__} #{x}"}
            end

            def error(type, data = nil)
              msg = MSGS[type]
              msg = msg % data if data
              errors << msg
              errors.tap {|e| puts "errors #{e}"}
            end
        end
      end
    end
  end
end
