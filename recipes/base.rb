#
# Cookbook Name:: tomcat
# Recipe:: base
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

include_recipe "ark"

version = node['tomcat']['version'].to_s

# the sysv init script requires an additional package
if platform? [ "centos","redhat","fedora"]
  distro = "el"
end

user node['tomcat']['user']

ark "tomcat" do
  url node['tomcat'][version]['url']
  checksum node['tomcat'][version]['checksum']
  version node['tomcat']['version']
  prefix_root "#{node['tomcat']['prefix_dir']}/tomcat"
  home_dir "#{node['tomcat']['prefix_dir']}/tomcat/default"
  owner 
end  
