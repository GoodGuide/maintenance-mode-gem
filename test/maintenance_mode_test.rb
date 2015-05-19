class MaintenanceModeTest
  class Delegation < Minitest::Test
    def persistence_method_stub
      @persistence_method_stub ||= Minitest::Mock.new
    end

    def setup
      MaintenanceMode.persistence = persistence_method_stub
    end

    def teardown
      @persistence_method_stub = nil
    end

    def test_enable
      persistence_method_stub.expect :enable, nil
      MaintenanceMode.enable

      persistence_method_stub.verify
    end

    def test_enable_with_message
      persistence_method_stub.expect :enable, nil, ['foo']
      MaintenanceMode.enable 'foo'

      persistence_method_stub.verify
    end

    def test_disable
      persistence_method_stub.expect :disable, nil
      MaintenanceMode.disable

      persistence_method_stub.verify
    end

    def test_enabled?
      persistence_method_stub.expect :enabled?, :foobar

      assert_equal :foobar, MaintenanceMode.enabled?
      persistence_method_stub.verify
    end

    def test_message
      persistence_method_stub.expect :message, :foobarbaz

      assert_equal :foobarbaz, MaintenanceMode.message
      persistence_method_stub.verify
    end

    def test_as_json
      persistence_method_stub.expect :message, 'foo'
      persistence_method_stub.expect :enabled?, true

      assert_equal({ enabled: true, message: 'foo' }, MaintenanceMode.as_json)
      persistence_method_stub.verify
    end
  end

  class PersistenceRegistration < Minitest::Test
    def setup
      MaintenanceMode.reset
    end

    def test_persistence_default
      assert_kind_of MaintenanceMode::NullPersistence, MaintenanceMode.persistence
    end

    def test_persist_with
      MaintenanceMode.persist_with :file, 'tmp/foo'
      assert_kind_of MaintenanceMode::FilePersistence, MaintenanceMode.persistence
      assert_equal 'tmp/foo', MaintenanceMode.persistence.pathname
    end

    def test_persist_with_not_registered
      assert_raises(KeyError) { MaintenanceMode.persist_with :foo }
    end

    def test_register_persistence_method
      fake_persistence_method_class = Class.new(Object)
      MaintenanceMode.register_persistence_method :foo, fake_persistence_method_class
      MaintenanceMode.persist_with :foo
      assert_kind_of fake_persistence_method_class, MaintenanceMode.persistence
    end
  end
end
