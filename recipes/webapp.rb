#
# Cookbook Name:: tomcat
# Recipe:: webapp
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2012, Food and Agriculture Organization of the United Nations
#
# license Apache v2.0
#

include_recipe "ark"
include_recipe "tomcat::base"

t = tomcat node['tomcat']['user'] do
  user node['tomcat']['user']
  action :install
  jvm_opts node['tomcat']['java_opts']
end

