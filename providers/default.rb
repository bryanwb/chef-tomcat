#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook Name:: tomcat
# Provider:: default
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

def get_distro
  if platform? [ "centos","redhat","fedora"]
    "el"
  else
    "debian"
  end
end

def get_resource_hash(resource)
  require 'pathname'
  resource_h = Hash.new
  resource_h['name'] = resource.name
  resource_h['home'] = node['tomcat']['home']
  resource_h['base'] = resource.base
  resource_h['context_dir'] = "#{resource_h['base']}/conf/Catalina/localhost"
  resource_h['log_dir'] = "#{resource_h['base']}/logs"
  resource_h['tmp_dir'] = "#{resource_h['base']}/temp"
  resource_h['work_dir'] = "#{resource_h['base']}/work"
  resource_h['webapp_dir'] = "#{resource_h['base']}/webapps"
  resource_h['pid_file'] = "#{resource_h['name']}.pid"
  resource_h['use_security_manager'] = node['tomcat']['use_security_manager']
  resource_h['user'] = resource.user
  resource_h['group'] = resource.user
  resource_h['port'] = resource.port
  resource_h['ajp_port'] = resource.ajp_port
  resource_h['ssl_port'] = resource.ssl_port
  resource_h['shutdown_port'] = resource.shutdown_port
  resource_h['jvm_opts'] = resource.jvm_opts
  resource_h['jmx_opts'] = resource.jmx_opts
  resource_h['webapp_opts'] = resource.webapp_opts
  resource_h['more_opts'] = resource.more_opts
  resource_h['unpack_wars'] = resource.unpack_wars
  resource_h['auto_deploy'] = resource.auto_deploy
  resource_h['env'] = resource.env
  
  resource_h
end
  
action :install do
  distro = get_distro
  # I create a new hash of the attributes because new_resource.to_hash
  # causes bizarre errors
  resource_h = get_resource_hash new_resource

  d = directory resource_h['base'] do
    owner resource_h['user']
    group resource_h['user']
    mode 0775
    action :nothing
  end
  d.run_action(:create)
  
  %w{ conf lib logs server shared temp webapps work }.each do |dir|
    d = directory "#{resource_h['base']}/#{dir}" do
      owner resource_h['user']
      group resource_h['user']
      recursive true
      mode 0775
      action :nothing
    end
    d.run_action(:create)
  end

  # don't have a need yet to template these files
  %w{ catalina.policy catalina.properties logging.properties context.xml web.xml tomcat-users.xml }.each do |file|
    ckbk_f = cookbook_file "#{resource_h['base']}/conf/#{file}" do
      cookbook "tomcat"
      source file
      owner resource_h['user']
      action :nothing
    end
    ckbk_f.run_action(:create)
  end
  
  t_init = template "/etc/init.d/#{resource_h['name']}" do
    cookbook "tomcat"
    path "/etc/init.d/#{resource_h['name']}"
    source "tomcat.init.#{distro}.erb"
    owner "root"
    group "root"
    mode "0774"
    variables( :name => resource_h['name'] )
    action :nothing
  end
  t_init.run_action(:create)
  
  t_default = template "/etc/default/#{resource_h['name']}" do
    cookbook "tomcat"
    source "default_tomcat.erb"
    owner "root"
    group "root"
    variables(:tomcat => resource_h)
    mode "0644"
    action :nothing
  end
  t_default.run_action(:create)

  
  t_server_xml = template "#{resource_h['base']}/conf/server.xml" do
    cookbook "tomcat"
    source "server.tomcat#{node['tomcat']['version']}.xml.erb"
    owner "#{resource_h['user']}"
    group "#{resource_h['user']}"
    variables(:tomcat => resource_h)
    mode "0644"
    action :nothing
  end
  t_server_xml.run_action(:create)

  s = service resource_h['name'] do
    service_name resource_h['name']
    supports :restart => true, :reload => true, :status => true
    action :nothing
    subscribes :restart, resources( :template =>
                                   [
                                    "#{resource_h['base']}/conf/server.xml",
                                    "/etc/default/#{resource_h['name']}",
                                    "/etc/init.d/#{resource_h['name']}"
                                   ])
  end
  s.run_action( :enable )

  new_resource.updated_by_last_action(true)
end

action :restart do
  ruby_block "restart the tomcat service" do
    block do
      r = resources(:service => new_resource.name )
      r.run_action(:restart)
    end
    action :create
  end
end

action :start do
  ruby_block "start the tomcat service" do
    block do
      r = resources(:service => new_resource.name )
      r.run_action(:start)
    end
    action :create
  end
end


action :remove do
  
end
