#
# Cookbook Name:: tomcat_installer
# Recipe:: default
# All rights reserved - Do Not Redistribute
#

case node['platform']
when 'debian', 'ubuntu'
  include_recipe 'apt'      
  package 'curl'             # Why do you need curl package if it is debian/Ubuntu? Where are you using it?
end

include_recipe 'java'


# What is "application" resource? Where does it come from? 
# I don't see an LWRP (Providers/Resources) or class definition (in Libraries) 
# How does this install tomcat?
# please explain in detail
application node[:tomcat_installer][:application_name] do 
  path node[:tomcat_installer][:application_path]
  repository node[:tomcat_installer][:war_uri]
  revision node[:tomcat_installer][:application_version]
  scm_provider Chef::Provider::RemoteFile::Deploy

  java_webapp 
  tomcat
  notifies :run, 'execute[restart_tomcat]', :delayed
end


# Also, can you explain how the notifies action in this resource and the above resource work?
# Will it first install tomcat, deploy war, restart tomcat and then send email or
# install tomcat, deploy war, send email and then restart?
execute 'restart_tomcat' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
  notifies :run, 'sendmail[notification]', :immediately
end

sendmail 'notification' do
  send_mail
end
