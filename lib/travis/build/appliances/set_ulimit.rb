require 'travis/build/appliances/base'

module Travis
  module Build
    module Appliances
      class SetUlimit < Base
        ULIMITS = {
          :n => 50000
        }

        def apply
          ULIMITS.each do |flag, new_value|
            sh.cmd "ulimit -#{flag} #{new_value}", echo: true
          end
        end
      end
    end
  end
end
