package "git"
package "nodejs"
package "memcached"

# Install rbenv and ruby
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "instedd-common::passenger"

rbenv_ruby "1.9.3-p484"
rbenv_gem "bundler" do
  ruby_version "1.9.3-p484"
end

# Install MySQL
include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database::mysql"

mysql_connection = {
  host: node['mysql']['server_host'],
  username: node['mysql']['admin_username'] || 'root',
  password: node['mysql']['admin_password'] || node['mysql']['server_root_password']
}

mysql_database "nuntium" do
  connection mysql_connection
end

# Install RabbitMQ
include_recipe "rabbitmq"
include_recipe "rabbitmq::mgmt_console"

rabbitmq_vhost node['nuntium']['amqp']['vhost'] do
  action :add
end

rabbitmq_user node['nuntium']['amqp']['user'] do
  password node['nuntium']['amqp']['password']
  action :add
end

rabbitmq_user node['nuntium']['amqp']['user'] do
  vhost node['nuntium']['amqp']['vhost']
  permissions ".* .* .*"
  action :set_permissions
end

rails_web_app "nuntium" do
  app_dir "/u/apps/nuntium"
  owner node['current_user']
  server_name node['nuntium']['host_name']
  config_files %w(amqp.yml database.yml google_oauth2.yml guisso.yml settings.yml twitter_oauth_consumer.yml)
  passenger_spawn_method :direct
  ssl node['nuntium']['web']['ssl']['enabled']
  ssl_cert_file node['nuntium']['web']['ssl']['cert_file']
  ssl_cert_key_file node['nuntium']['web']['ssl']['cert_key_file']
  ssl_cert_chain_file node['nuntium']['web']['ssl']['cert_chain_file']
end

