#
# Cookbook Name:: tomcat
# Recipe:: webapp_jdbc
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2012, Food and Agriculture Organization of the United Nations
#
# license Apache v2.0
#

include_recipe "ark"
include_recipe "tomcat::base"
include_recipe "maven"
include_recipe "tomcat::_jdbc_password"
include_recipe "tomcat::_load_jdbc_params"

t = tomcat node['tomcat']['user'] do
  user node['tomcat']['user']
  action :install
  jvm_opts node['tomcat']['java_opts']
end

maven node['tomcat']['jdbc']['driver']['name'] do
  group_id node['tomcat']['jdbc']['driver']['name'] 
  version  node['tomcat']['jdbc']['driver']['version']
  dest "#{t.base}/lib"
  owner node['tomcat']['user']
end

directory "#{t.base}/conf/Catalina/localhost" do
  recursive true
  owner node['tomcat']['user']
end

template "jdbc context" do
  path "#{t.base}/conf/Catalina/localhost/#{node['tomcat']['application']}.xml"
  source "context.xml.erb"
  owner node['tomcat']['user']
end

