#
# Cookbook Name:: tomcat
# Attributes:: default
# Author:: Bryan Berry (<bryan.berry@gmail.com>)
#
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

default["tomcat"]["version"] = "7"
version = node["tomcat"]["version"]
default["tomcat"]["prefix_dir"] = "/usr/local"
prefix_dir = node["tomcat"]["prefix_dir"]
default["tomcat"]["home"] = "#{prefix_dir}/tomcat/default"
default["tomcat"]["base"] = "#{prefix_dir}/tomcat/default"
tomcat_base = node["tomcat"]["base"]
default["tomcat"]["context_dir"] = "#{tomcat_base}/conf/Catalina/localhost"
default["tomcat"]["log_dir"] = "#{tomcat_base}/logs"
default["tomcat"]["tmp_dir"] = "#{tomcat_base}/temp"
default["tomcat"]["work_dir"] = "#{tomcat_base}/work"
default["tomcat"]["webapp_dir"] = "#{tomcat_base}/webapps"
default["tomcat"]["pid_file"] = "tomcat#{version}.pid"
default['tomcat']['shutdown_wait'] = '5'

# runtime settings
default["tomcat"]["use_security_manager"] = false
default["tomcat"]["user"] = "tomcat#{version}"
default["tomcat"]["group"] = "tomcat#{version}"
default["tomcat"]["http_port"] = 8080
default["tomcat"]["ssl_port"] = 8443
default["tomcat"]["ajp_port"] = 8009
default["tomcat"]["shutdown_port"] = 8005
default["tomcat"]["unpack_wars"] = true
default["tomcat"]["auto_deploy"] = true

# all the *_opts are later combined into JAVA_OPTS
default["tomcat"]["jvm_opts"] = ["-Xmx128M", "-Djava.awt.headless=true"]
default["tomcat"]["jmx_opts"] = []
default["tomcat"]["webapp_opts"] = []
default["tomcat"]["more_opts"] = []

# urls for arks and sha256 checksum for each
default['tomcat']['6']['url'] = 'http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.35/bin/apache-tomcat-6.0.35.tar.gz'
default['tomcat']['6']['checksum'] = 'b28c9cbc2a8ef271df646a50410bab7904953b550697efb5949c9b2d6a9f3d53'
default['tomcat']['7']['url'] = 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.32/bin/apache-tomcat-7.0.32.tar.gz'
default['tomcat']['7']['checksum'] = 'c26ae0bc424e2639f5c77eb4d274a026c5a584a404dbdbb247ab6d2c3ebe8258'
