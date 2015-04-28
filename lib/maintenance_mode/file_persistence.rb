class MaintenanceMode
  class FilePersistence
    def initialize(pathname)
      @pathname = pathname
    end

    attr_reader :pathname

    def enabled?
      @pathname.file?
    end

    def enable(message='')
      @pathname.write(message)
    end

    def disable
      return unless enabled?
      @pathname.unlink
    end

    def message
      return unless enabled?
      contents = @pathname.read.to_s
      contents == '' ? nil : contents
    end
  end
end
