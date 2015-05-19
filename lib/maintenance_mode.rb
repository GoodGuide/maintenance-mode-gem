require 'forwardable'
require 'maintenance_mode/version'
require 'maintenance_mode/file_persistence'
require 'maintenance_mode/null_persistence'

class MaintenanceMode
  class << self
    extend Forwardable
    def_delegator :persistence, :enable
    def_delegator :persistence, :disable
    def_delegator :persistence, :message
    def_delegator :persistence, :enabled?

    def as_json
      {
        enabled: enabled?,
        message: message,
      }
    end

    attr_writer :persistence

    def persistence
      @persistence || NullPersistence.new
    end

    def persist_with(persistence_method, *args, &block)
      self.persistence = persistence_methods.fetch(persistence_method).new(*args, &block)
    end

    def register_persistence_method(name, persistence_method_class)
      persistence_methods[name] = persistence_method_class
    end

    def reset
      @persistence_methods = nil
      @persistence = nil
    end

    private

    def persistence_methods
      @persistence_methods ||= {
        file: FilePersistence
      }
    end
  end
end
