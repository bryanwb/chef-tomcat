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
set["tomcat"]["prefix_dir"] = "/usr/local"
prefix_dir = node["tomcat"]["prefix_dir"]
set["tomcat"]["home"] = "#{prefix_dir}/tomcat/default"
set["tomcat"]["base"] = "#{prefix_dir}/tomcat/default"
tomcat_base = node["tomcat"]["base"]
set["tomcat"]["context_dir"] = "#{tomcat_base}/conf/Catalina/localhost"
set["tomcat"]["log_dir"] = "#{tomcat_base}/logs"
set["tomcat"]["tmp_dir"] = "#{tomcat_base}/temp"
set["tomcat"]["work_dir"] = "#{tomcat_base}/work"
set["tomcat"]["webapp_dir"] = "#{tomcat_base}/webapps"
set["tomcat"]["pid_file"] = "tomcat#{version}.pid"

# runtime settings
set["tomcat"]["use_security_manager"] = false
set["tomcat"]["user"] = "tomcat#{version}"
set["tomcat"]["group"] = "tomcat#{version}"
set["tomcat"]["port"] = 8080
set["tomcat"]["ssl_port"] = 8443
set["tomcat"]["ajp_port"] = 8009
set["tomcat"]["shutdown_port"] = 8005
set["tomcat"]["unpack_wars"] = true
set["tomcat"]["auto_deploy"] = true

# all the *_opts are later combined into JAVA_OPTS
set["tomcat"]["jvm_opts"] = ["-Xmx128M", "-Djava.awt.headless=true"]
set["tomcat"]["jmx_opts"] = []
set["tomcat"]["webapp_opts"] = []
set["tomcat"]["more_opts"] = []

# urls for arks and sha256 checksum for each
set['tomcat']['6']['url'] = 'http://apache.mirrors.tds.net/tomcat/tomcat-6/v6.0.35/bin/apache-tomcat-6.0.35.tar.gz'
set['tomcat']['6']['checksum'] = 'b28c9cbc2a8ef271df646a50410bab7904953b550697efb5949c9b2d6a9f3d53'
set['tomcat']['7']['url'] = 'http://apache.mirrors.tds.net/tomcat/tomcat-7/v7.0.26/bin/apache-tomcat-7.0.26.tar.gz'
set['tomcat']['7']['checksum'] = '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
