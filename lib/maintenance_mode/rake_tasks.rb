require 'maintenance_mode'

class MaintenanceMode
  class RakeTasks
    extend Rake::DSL

    def self.install
      namespace :maintenance do
        desc 'Enable MaintenanceMode - optional message can be passed as only argument or use $MESSAGE'
        task :enable, [:message] => [:configure] do |_, args|
          MaintenanceMode.enable(ENV.fetch('MESSAGE', args[:message]))
        end

        desc 'Disable MaintenanceMode'
        task :disable => [:configure] do
          MaintenanceMode.disable
        end

        desc 'Empty hook to configure MaintenanceMode before enable/disable'
        task :configure
      end
    end
  end
end

MaintenanceMode::RakeTasks.install
