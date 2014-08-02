package "git"

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby "1.9.3-p484"
rbenv_gem "bundler" do
  ruby_version "1.9.3-p484"
end

include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database::mysql"

mysql_database "nuntium" do
  connection(
    host: 'localhost',
    username: 'root',
    password: node['mysql']['server_root_password']
  )
end

application "nuntium" do
  path "/u/apps/nuntium"
  repository "https://bitbucket.org/instedd/nuntium.git"

  before_symlink do
    execute "install bundle" do
      command "/opt/rbenv/shims/bundle install --path #{shared_path}/bundle --jobs=8 --deployment --without development test"
      cwd release_path
    end
  end
end


