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

def update_resource_params(resource)
  resource.params['context_dir'] = "#{resource.base}/conf/Catalina/localhost"
  resource.params['log_dir'] = "#{resource.base}/logs"
  resource.params['tmp_dir'] = "#{resource.base}/temp"
  resource.params['work_dir'] = "#{resource.base}/work"
  resource.params['webapp_dir'] = "#{resource.base}/webapps"
  resource.params['pid_file'] = "#{resource.name}.pid"
  resource.params['use_security_manager'] = node['tomcat']['use_security_manager']
end
  
action :install do
  distro = get_distro
  update_resource_params new_resource

  directory new_resource.base do
    owner new_resource.user
    group new_resource.user
    mode 0775
    action :create
  end
  
  %w{ conf lib logs server shared temp webapps work }.each do |dir|
    directory "#{new_resource.base}/#{dir}" do
      owner new_resource.user
      group new_resource.user
      recursive true
      mode 0775
      action :create
    end
  end

  # don't have a need yet to template these files
  %w{ catalina.policy catalina.properties logging.properties context.xml web.xml tomcat-users.xml }.each do |file|
    cookbook_file "#{new_resource.base}/conf/#{file}" do
      cookbook "tomcat"
      source file
      owner new_resource.user
      action :create
    end
  end
  
  template "/etc/init.d/#{new_resource.name}" do
    cookbook "tomcat"
    path "/etc/init.d/#{new_resource.name}"
    source "tomcat.init.#{distro}.erb"
    owner "root"
    group "root"
    mode "0774"
    variables( :name => new_resource.name )
    action :create
  end
  
  template "/etc/default/#{new_resource.name}" do
    cookbook "tomcat"
    source "default_tomcat.erb"
    owner "root"
    group "#{new_resource.user}"
    variables(:tomcat => new_resource)
    mode "0664"
    if new_resource.manage_config_file
      action :create
    else
      action :create_if_missing
    end
  end
  
  template "#{new_resource.base}/conf/server.xml" do
    cookbook "tomcat"
    source "server.tomcat#{node['tomcat']['version']}.xml.erb"
    owner "#{new_resource.user}"
    group "#{new_resource.user}"
    variables(:tomcat => new_resource)
    mode "0644"
    if new_resource.manage_config_file
      action :create
    else
      action :create_if_missing
    end
  end
  
  service new_resource.name do
    service_name new_resource.name
    supports :restart => true, :reload => true, :status => true
    subscribes :restart, resources( :template =>
                                   [
                                    "#{new_resource.base}/conf/server.xml",
                                    "/etc/default/#{new_resource.name}",
                                    "/etc/init.d/#{new_resource.name}"
                                   ])
    if new_resource.clustered
      action :nothing
    else
      action :enable
    end
  end

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
