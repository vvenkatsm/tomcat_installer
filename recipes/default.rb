#
# Cookbook Name:: tomcat_installer
# Recipe:: default
# All rights reserved - Do Not Redistribute
#

case node['platform']
when 'debian', 'ubuntu'
  include_recipe 'apt'
  package 'curl' 
end

include_recipe 'java'

application node[:tomcat_installer][:application_name] do 
  path node[:tomcat_installer][:application_path]
  repository node[:tomcat_installer][:war_uri]
  revision node[:tomcat_installer][:application_version]
  scm_provider Chef::Provider::RemoteFile::Deploy

  java_webapp 
  tomcat
  notifies :run, 'execute[restart_tomcat]', :delayed
end

execute 'restart_tomcat' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
  notifies :run, 'sendmail[notification]', :immediately
end

sendmail 'notification' do
  send_mail
end
