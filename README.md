# MaintenanceMode

This provides a simple interface to a "maintenance mode" toggle with optional
maintenance message. It's not specific to maintenance mode, really, and could be
used whenever a similar switch is needed.

[![Build Status](https://travis-ci.org/GoodGuide/maintenance_mode.svg?branch=master)](https://travis-ci.org/GoodGuide/maintenance_mode)

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

There is no magic here; if you want to apply this to your web app, just build a
response handler with the result of `MaintenanceMode.as_json` or something to
that effect.

There are also rake tasks to toggle MaintenanceMode:

```shell
rake maintenance:enable
rake maintenance:enable MESSAGE="Oh Noes!"
rake 'maintenance:enable[Oh Noes!]' # also works
rake maintenance:disable
```

To get these tasks, you'll have to add this line to your `Rakefile`:

```ruby
# Rakefile
require 'maintenance_mode/rake_tasks'
```

## Configuration

The persistence mechanism is configurable. Currently, the only one which ships with this gem just uses a file on disk.

Without configuration, the library will act on memory only (which of course means rake tasks have no effect on a server process). To configure the file-based persistence, use the following:

```ruby
MaintenanceMode.persist_with :file, Rails.root.join('config/maintenance-mode')
# equivalent to
MaintenanceMode.persistence = MaintenanceMode::FilePersistence.new(
    Rails.root.join('config/maintenance-mode'))
```

n.b. The argument to `FilePersistence` must be a `Pathname` instead of merely a string.

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

  def initialize(redis, key)
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

r = MyRedisMaintenancePersistence.new(Redis.new, 'maintenance-mode')
MaintenanceMode.persistence = r

# If writing as a separately distributed library, you could have your code
# register itself:
MaintenanceMode.register_persistence_method :redis, MyRedisMaintenancePersistence

# then people can use it via:
MaintenanceMode.persist_with :redis, Redis.new, 'maintenance-mode'
```

## Contributing

Pull requests welcome.
