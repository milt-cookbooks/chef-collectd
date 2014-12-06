# Collectd [![Build Status](https://secure.travis-ci.org/miah/chef-collectd.png)](http://travis-ci.org/miah/chef-collectd)

# DESCRIPTION #

Configure and install the [collectd](http://collectd.org/) monitoring daemon.

# REQUIREMENTS #

This cookbook has only been tested on Ubuntu 10.04 and 12.04.

The following cookbooks are required:

+ [apt](http://community.opscode.com/cookbooks/apt)
+ [ark](http://community.opscode.com/cookbooks/ark)
+ [build-essential](http://community.opscode.com/cookbooks/build-essential)
+ [logrotate](http://community.opscode.com/cookbooks/logrotate)
+ [runit](http://community.opscode.com/cookbooks/runit)
+ [yum](http://community.opscode.com/cookbooks/yum)
+ [yum-epel](http://community.opscode.com/cookbooks/yum-epel)

# ATTRIBUTES #

+ collectd.basedir - Base folder for collectd output data.
+ collectd.plugin_dir - Base folder to find plugins.
+ collectd.types_db - Path to the files to read graph type information from.
+ collectd.interval - Time period in seconds to wait between data reads.

# USAGE #

Three main recipes are provided:

+ collectd::client or collectd::default - Install a unconfigured collectd
+ collectd::client_collectd - Install collectd and configure it to send data to a collectd server.
+ collectd::client_graphite - Install collectd and configure it to send data to a carbon server.
+ collectd::server - Install collectd and configure it to recieve data from clients.

The client recipe will use the search index to automatically locate the server hosts, so no manual configuration is required.

# PLUGINS #

Two main recipes for configuring [collectd plugins](https://collectd.org/wiki/index.php/Table_of_Plugins) are provided:

+ collectd::data_bag_plugins - Configure collectd plugins defined in data bags
+ collectd::nested_plugins - Configure collectd plugins defined in nested attributes

## collectd::data_bag_plugins ##

The `collectd::data_bag_plugins` recipe can be used by adding each plugin to load as a data bag. Settings for each
plugin should be added under the `options` key.

For example:

`data_bags/collectd/df.json`:

```ruby
{
  "id": "df",
  "options": {
    "f_s_type": "devfs",
    "ignore_selected": true,
    "report_by_device": true,
    "report_reserved": true
  }
}
```

`data_bags/collectd/disk.json`:

```ruby
{
  "id": "disk",
  "options": {
    "#": " This should collect data for all disk names beginning with 'hd'",
    "disk": "/^hd/",
    "ignore_selected": false
  }
}
```

`data_bags/collectd/cpu.json`:

```ruby
{
  "id": "cpu",
  "options": {}
}
```

`data_bags/collectd/swap.json`:

```ruby
{
  "id": "swap",
  "options": {}
}
```

`data_bags/collectd/memory.json`:

```ruby
{
  "id": "memory",
  "options": {}
}
```

`data_bags/collectd/interface.json`:

```ruby
{
  "id": "interface",
  "options": {
    "interface": "lo",
    "ignore_selected": true
  }
}
```

## collectd::nested_plugins ##

The `collectd::nested_plugins` recipe can be used by adding each plugin to load, along with any settings as a nested Hash.
(Note: chef uses a [Mash](http://docs.opscode.com/essentials_cookbook_attribute_files.html#attribute-notation) behind the scenes)

For example, to add a set of collectd plugins in a role:

```ruby
default_attributes({
  collectd: {
      plugin_dir: "/usr/lib/collectd", 
      plugins: {
          df: {
              f_s_type: "devfs", 
              ignore_selected: true, 
              report_by_device: true, 
              report_reserved: true
          }, 
          disk: {}, 
          cpu: {}, 
          swap: {}, 
          memory: {}, 
          interface: {
            interface: "lo",
            ignore_selected: true
          }
      }
  }
})
```

## LWRPs ##

A lwrp is included for configuring plugins.

### collectd_plugin ###

You may use the `collectd_plugin` provider to configure and enable collectd plugins.

```ruby
%w(disk entropy memory swap).each do |plug|
  collectd_plugin plug
end

collectd_plugin 'syslog' do
  options :log_level => 'info',
    :notify_level => 'warning'
end

collectd_plugin 'tcpconns' do
  options :listening_ports => true
end

collectd_plugin 'myplugin' do
  type 'exec'
  options :exec => ['user', '/path/to/exec.sh']
end

# Taken from http://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_filecount
collectd_plugin 'qmail' do
  type 'filecount'
  options 'Directory' => {
    '/var/qmail/queue/mess' => {
      :instance => 'qmail-message'
    },
    '/var/qmail/queue/todo' => {
      :instance => 'qmail-todo'
    }
  }
end

# Taken from https://collectd.org/wiki/index.php/Plugin:Tail#Invalid_SSH_login_attempts
collectd_plugin 'sshd' do
  type 'tail'
  options :file => {
    '/var/log/auth.log' => {
      :instance => 'auth',
      :match => [
        {
          :regex => "\\<sshd[^:]*: Invalid user [^ ]+ from\\>",
          :d_s_type => 'CounterInc',
          :type => 'counter',
          :instance => 'sshd-invalid_user'
        }
      ]
    }
  }
end
```

The `options` hash is converted to collectd-style settings automatically.
Any symbol key will be converted to camel-case. In the above example
`:listening_ports` will be output as the key `ListeningPorts`. If the key is
already a string, this conversion is skipped. If the value is an array, it
will be output as a separate line for each element.

### purge_plugins ###

To purge unused plugins create a ruby block after all your other plugin declarations.  This will only remove plugins that that were originally declared using the collectd_plugin lwrp.

```ruby
ruby_block 'collectd_purge_plugins' do
  block { collectd_purge_plugins() }
end
```

### collectd_authfile ###

You may use the `collectd_authfile` provider to create a collectd authfile by adding and removing users.

```ruby
collectd_authfile 'gregf' do
  password  supersecure
end

collectd_authfile 'baduser' do
  action :remove
end
```

# LICENSE & AUTHORS #

+ Author:: Miah Johnson (<miah@chia-pet.org>)
+ Author:: Phillip Gentry (<phillip@cx.com>)
+ Author:: Noah Kantrowitz (<noah@coderanger.net>)
+ Author:: Scott M. Likens (<scott@likens.us>)
+ Author:: Greg Fitzgerald (<greg@gregf.org>)

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
