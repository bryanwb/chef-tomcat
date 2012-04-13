#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: tomcat
# Resource:: default
#
# Copyright 2012, Bryan w. Berry
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


actions :install, :remove, :restart, :start

attr_accessor :port, :ajp_port, :ssl_port, :shutdown_port, :host_name
attr_accessor :unpack_wars, :auto_deploy, :jvm_opts, :jmx_opts, :webapp_opts
attr_accessor :more_opts, :user, :context_dir, :log_dir, :tmp_dir, :work_dir
attr_accessor :webapp_dir, :base, :pid_file, :use_security_manager, :group

attribute :port, :kind_of => Integer, :default => 8080
attribute :ajp_port, :kind_of => Integer, :default => 8009
attribute :ssl_port, :kind_of => Integer, :default => 8443
attribute :shutdown_port, :kind_of => Integer, :default => 8005
attribute :host_name, :kind_of => String, :default => "localhost"
attribute :unpack_wars, :equal_to => [true, false], :default => true
attribute :auto_deploy, :equal_to => [true, false], :default => true
attribute :jvm_opts, :kind_of => Array, :default => ["-Djava.awt.headless=true", "-Xmx128M"]
attribute :jmx_opts, :kind_of => Array, :default => []
attribute :webapp_opts, :kind_of => Array, :default => []
attribute :more_opts, :kind_of => Array, :default => []
attribute :env, :kind_of => Array, :default => []
attribute :user, :kind_of => String, :required => true
  
# we have to set default for the supports attribute
# in initializer since it is a 'reserved' attribute name
def initialize(*args)
  require 'pathname'
  super
  @action = :install
  catalina_parent = Pathname.new(node['tomcat']['home']).parent.to_s
  @base = "#{catalina_parent}/#{@name}"
  @supports = {:report => true, :exception => true}
end
