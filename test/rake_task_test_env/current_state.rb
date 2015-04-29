require 'json'
require 'maintenance_mode'
require_relative './maintenance_mode_config'

puts MaintenanceMode.as_json.to_json
