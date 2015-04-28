# MaintenanceMode

This provides a simple interface to a "maintenance mode" toggle with optional
maintenance message. It's not specific to maintenance mode, really, and could be
used whenever a similar switch is needed.

## Usage

```ruby
MaintenanceMode.enable
MaintenanceMode.as_json # => { "enabled": true, "message": null }
MaintenanceMode.enable "we'll be back soon"
MaintenanceMode.as_json # => { "enabled": true, "message": "we'll be back soon" }
MaintenanceMode.enabled? # => true
MaintenanceMode.message # => "we'll be back soon"
MaintenanceMode.disable
MaintenanceMode.enabled? # => false
```

There are also rake tasks to toggle MaintenanceMode:

```shell
rake maintenance:enable
rake maintenance:enable MESSAGE="Oh Noes!"
rake maintenance:disable
```

## Configuration

The persistence mechanism is configurable. Currently, the only one which ships with this gem just uses a file on disk.

Without configuration, the library will act on memory only (which of course means rake tasks have no effect on a server process). To configure the file-based persistence, use the following:

```ruby
MaintenanceMode.persist_with :file, Rails.root.join('config/maintenance-mode')
# equivalent to
MaintenanceMode.persistence = MaintenanceMode::File.new(
    Rails.root.join('config/maintenance-mode'))
```

### Custom logic

You can set `MaintenanceMode.persistence` to any object which responds to the
correct interface.

- `enable(message=nil)`
- `disable`
- `enabled?`
- `message`

Here's an example using Redis for persistence (this is untested; just for example):

```ruby
class MyRedisMaintenancePersistence
  NULL = '__null__'

  def initialize(redis:, key:)
    @redis = redis
    @key = key
  end

  def enable(message=NULL)
    @redis.set @key, message
  end

  def disable
    @redis.del @key
  end

  def enabled?
    !!@redis.get(@key)
  end

  def message
    v = @redis.get(@key)
    v == NULL ? nil : v
  end
end

r = MyRedisMaintenancePersistence.new(redis: Redis.new, key: 'maintenance-mode')
MaintenanceMode.persistence = r
```

## Contributing

Pull requests welcome.
