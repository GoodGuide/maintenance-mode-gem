require 'maintenance_mode'
require 'pathname'

path = Pathname.new(File.expand_path('../maintenance.enabled', __FILE__))
MaintenanceMode.persist_with :file, path
