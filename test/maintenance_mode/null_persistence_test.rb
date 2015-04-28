require 'test_helper'

class MaintenanceMode::NullPersistenceTest < Minitest::Test
  def subject
    MaintenanceMode::NullPersistence.new
  end

  def test_enable
    subject.enable
    assert !subject.enabled?
  end

  def test_enable_with_message
    subject.enable 'foo'
    assert_nil subject.message
    assert !subject.enabled?
  end

  def test_enable_when_enabled
    subject.enable 'foo'
    subject.enable

    assert !subject.enabled?
  end

  def test_disable
    subject.disable
  end

  def test_enabled?
    assert !subject.enabled?
  end

  def test_message
    assert_nil subject.message
  end
end
