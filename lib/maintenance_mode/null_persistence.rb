class MaintenanceMode
  class NullPersistence
    def enabled?
      false
    end

    def enable(message=nil); end

    def disable; end

    def message; end
  end
end
