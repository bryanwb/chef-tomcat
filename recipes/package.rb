#
# Cookbook Name:: tomcat
# Recipe:: package
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2010, Opscode, Inc.
# Copyright 2012, Bryan W. Berry
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# let's set the tomcat attributes to the ones that match the ubuntu
# packages, damn the FHS

version = node['tomcat']['version'].to_s
node["tomcat"]["user"] = "tomcat#{version}"
node["tomcat"]["group"] = "tomcat#{version}"
node["tomcat"]["home"] = "/usr/share/tomcat#{version}"
node["tomcat"]["base"] = "/var/lib/tomcat#{version}"
node["tomcat"]["config_dir"] = "/etc/tomcat#{version}"
config_dir = node["tomcat"]["config_dir"]
node["tomcat"]["log_dir"] = "/var/log/tomcat#{version}"
node["tomcat"]["tmp_dir"] = "/tmp/tomcat#{version}-tmp"
node["tomcat"]["work_dir"] = "/var/cache/tomcat#{version}"
node["tomcat"]["context_dir"] = "#{config_dir}/Catalina/localhost"
node["tomcat"]["webapp_dir"] = "/var/lib/tomcat#{version}/webapps"

# this recipe only supports debian or ubuntu
unless platform? ["debian", "ubuntu"]
  Chef::Application::fatal!("This recipe only supports Ubuntu or Debian")
end

tomcat_pkgs = [ "tomcat#{version}", "tomcat#{version}-admin"]


tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service "tomcat" do
  service_name "tomcat#{version}"
  supports :restart => true, :reload => true, :status => true
  action [:enable, :start]
end

template "tomcat#{version}" do
  path "/etc/init.d/tomcat#{version}"
  source "tomcat.init.debian.erb"
  owner "root"
  group "root"
  mode "0774"
  variables( :name => "tomcat#{version}")
  notifies :restart, resources(:service => "tomcat")
end

template "/etc/default/tomcat#{version}" do
  source "default_tomcat.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:tomcat => node['tomcat'].to_hash)
  notifies :restart, resources(:service => "tomcat")
end


template "/etc/tomcat#{version}/server.xml" do
  source "server.tomcat#{version}.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:tomcat => node['tomcat'].to_hash)
  notifies :restart, resources(:service => "tomcat")
end
