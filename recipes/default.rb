package "git"

# Install rbenv and ruby
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby "1.9.3-p484"
rbenv_gem "bundler" do
  ruby_version "1.9.3-p484"
end

# Install MySQL
include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database::mysql"

mysql_connection = {
  host: 'localhost',
  username: 'root',
  password: node['mysql']['server_root_password']
}

mysql_database "nuntium" do
  connection mysql_connection
end

include_recipe "nodejs"

application "nuntium" do
  path "/u/apps/nuntium"
  repository "https://bitbucket.org/instedd/nuntium.git"

  rails do
    bundler true
    bundle_command "#{node[:rbenv][:root_path]}/shims/bundle"

    database(
      database: "nuntium",
      adapter: "mysql2",
      username: "root",
      password: node['mysql']['server_root_password']
    )
  end

  before_symlink do
    rbenv_execute "create database" do
      command "bundle exec rake db:migrate"
      environment "RAILS_ENV" => "production"
      cwd release_path
    end
  end

  before_restart do
    file "#{release_path}/.env" do
      content "RAILS_ENV=production"
    end

    rbenv_execute "foreman export" do
      command "bundle exec foreman export -a nuntium -u root -c 'worker_fast=1,worker_slow=1,xmpp=1,smpp=1,msn=1,cron=1,sched=1' upstart /etc/init"
      cwd release_path
    end
  end
end


