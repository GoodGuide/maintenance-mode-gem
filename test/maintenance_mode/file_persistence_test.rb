require 'test_helper'
require 'pathname'
require 'tempfile'

class MaintenanceMode::FilePersistenceTest < Minitest::Test
  def _file
    @tempfile ||= Tempfile.new('MaintenanceMode').tap { |f| f.close }
    Pathname.new(@tempfile.path)
  end

  def set_contents(contents)
    File.open(_file, 'w') do |file|
      file.write contents
    end
  end

  def setup
    _file.unlink
  end

  def subject
    MaintenanceMode::FilePersistence.new(_file)
  end

  def test_enable
    assert !_file.file?, 'file should not exist'
    subject.enable

    assert _file.file?, 'file should exist'
  end

  def test_enable_with_message
    assert !_file.file?, 'file should not exist'
    subject.enable 'foo'

    assert _file.file?, 'file should exist'
    assert_equal 'foo', _file.read.to_s
  end

  def test_enable_when_enabled
    assert !_file.file?, 'file should not exist'
    subject.enable 'foo'
    subject.enable

    assert _file.file?, 'file should exist'
    assert_equal '', _file.read.to_s
  end

  def test_disable
    set_contents('foo')
    assert _file.file?, 'file should exist'
    subject.disable

    assert !_file.file?, 'file should not exist'
  end

  def test_disable_when_not_enabled
    subject.disable

    assert !_file.file?, 'file should not exist'
  end

  def test_enabled?
    set_contents('foo')
    assert subject.enabled?
    _file.unlink
    assert !subject.enabled?
  end

  def test_message
    set_contents('foobar')

    assert_equal 'foobar', subject.message
  end

  def test_message_when_empty
    set_contents('')

    assert_equal nil, subject.message
  end

  def test_message_when_not_enabled
    assert_equal nil, subject.message
  end
end
