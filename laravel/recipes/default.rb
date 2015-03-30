#
# Cookbook Name:: laravel
# Recipe:: default
#
# Copyright 2015, SOFTSERVLET 
#
# All rights reserved - Do Not Redistribute
#
#
# Cookbook Name:: env
# Recipe:: default
#
# Copyright 2015, SOFTSERVLET 
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt"

include_recipe "vim"
include_recipe "git"
include_recipe "nginx"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php-fpm"
include_recipe "composer"
include_recipe "nodejs"
include_recipe "ffmpeg2"



### install mysql and set default root user
mysql_service 'default' do
  version '5.6'
  bind_address '0.0.0.0'
  port '3306'  
  initial_root_password 'root'
  action [:create, :start]
end
### install mysql client
mysql_client 'default' do
  action :create
end


#install mysql2 gem
mysql2_chef_gem 'default' do
  gem_version '0.3.17'
  action :install
end

# deploy your sites configuration from the files/ driectory in your cookbook
#cookbook_file "#{node['nginx']['dir']}/sites-available/vaas.dev" do
#  owner "dev"
#  group "dev"
#  mode  "0644"
#end

# enable your sites configuration using a definition from the nginx cookbook
#nginx_site "vaas.dev"
#  enable true
#end

# create needed directories
directory "/etc/nginx/vhosts" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


# set php-sapi for php-fpm/nginx
cookbook_file "/etc/nginx/vhosts/php-sapi" do
  source "php-sapi"
  action :create
end



# install npm dependencies
# nodejs_npm "grunt" 
# nodejs_npm "yeoman"

nodejs_npm "express"
nodejs_npm "grunt" 
nodejs_npm "grunt-cli"
nodejs_npm "yo"
nodejs_npm "gulp"


# install php php-mcrypt
node.default['php']['ext_conf_dir'] = "/etc/php5/fpm/conf.d/";
include_recipe "php-mcrypt"
# end php-mcrypt installation

execute "php5enmod mcrypt" do                                             
  user "root"                                                                
  action :run                                                                   
end

# change PHP configuration to development environment by copy a pre-defined php.ini
cookbook_file "/etc/php5/fpm/php.ini" do
  source "php/php.ini"
  action :create
end

# restart nginx after vaas vhost has been copied
service "nginx" do
  action :restart
end

service "php5-fpm" do
  action :restart
end

# node['authorization']['sudo']['users'] = ['dev']
# node['authorization']['sudo']['passwordless'] = false

node.default['authorization']['sude']['users'] = ['dev']
node.default['authorization']['sudo']['passwordless'] = false

