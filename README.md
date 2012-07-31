Description
===========

Installs and configures the Tomcat, Java servlet engine and webserver.


Requirements
============

Platform: 

* CentOS, Red Hat, Fedora (OpenJDK)

The following Opscode cookbooks are dependencies:

* java, ark, maven


Attributes
==========

* prefix_dir - /usr/local/, /var/lib/, etc.

Recipes
=======

* default.rb -- installs tomcat via debian package only on a
debian based distribution. Otherwise installs via tomcat7_binary.rb
* package.rb -- installs tomcat7 unless node['tomcat']['version'] set
to 6. The package typically installs a system service.
* ark.rb installs a vanilla tomcat and creates a service
* base.rb  installs the tomcat from the binary provided by
tomcat.apache.org, will use version 7 unless node['tomcat']['version'] set
to 6. No tomcat service is installed.

All of the default webapps such as "ROOT" and "manager" are removed in the tomcat::ark recipe

ark
---

This recipe creates a vanilla tomcat installation based on the tarball
of bytecode available from http://tomcat.apache.org and places it in 
${prefix_dir}. Additionally, it configures a system v
init script and creates the symlink

    ${prefix_dir}/tomcat/default -> ${prefix_dir}/tomcat/tomcat{6,7}


base
----

It creates an installation of tomcat to prefix_dir. It does very
little besides that.

By default it uses the tomcat 7 by including tomcat7 recipe

This recipe is intended to be used together with the CATALINA_BASE method to install
multiple tomcat instances that use the same set of tomcat installation
files. This recipe does not add any services. It is intended to be used together with the tomcat lwrp.

    ${prefix_dir}/tomcat/tomcat{6,7}  # CATALINA_HOME

and creates a symlink to that directory

    ${prefix_dir}/tomcat/default -> ${prefix_dir}/tomcat/tomcat{6,7}



Resources/Providers
===================

tomcat

# Actions

- :install: install
- :remove: remove the instance

# Attribute Parameters

- http_port: port_num or true/false, default to true and 8080
- ajp_port:  port_num or true/false, default to true and 8009
- shutdown_port: port_num or true/false, default to 8005
- host_name: name for Host element, defaults to localhost
- session_timeout: global session timeout set in conf/web.xml
- unpack_wars: defaults to true
- auto_deploy: defaults to true
- jvm_opts: Array of options for the JVM
- jmx_opts: Array of JMX monitoring options
- jmx_access: String containing username and access permissions, will
  be written to the jmxremote.access file
- jmx_password: String containing username and password, will
  be written to the jmxremote.password file
- jmx_access_file: the file that the access role and permissions will
  be written to, defaults to `CATALINA_BASE/conf/jmxremote.access`
- jmx_password_file: the file that the username and password will
  be written to, defaults to `CATALINA_BASE/conf/jmxremote.password`
- manage_config_file: whether to update the configuration files
  /etc/default/app_name, `CATALINA_BASE/conf/server.xml`, and
  /etc/init.d/app_name after initial creation. If false, those files
  will not be changed after initial templating. Useful if you have
  devs who want control of their tomcat instance but don't want to
  learn chef. Great for massive configuration drift.
- webapp_opts: (Deprecated) Array of directives passed to a webapp
- more_opts: (Deprecated) crap that doesn't fit anywhere else
- service_name: an alternate name for the init script, useful if you are using
  a clustering tool like Pacemaker or heartbeat to manage the tomcat
  service
- clustered: set to true if you do not want the tomcat service to
  start automatically, defaults to false
- env: environment variables to export in init script
- user: user to run the tomcat as
- shutdown_wait: how long the shutdown script should wait before
  killing the process


An exception will be thrown if one of the values specified by *_port
is already in use by another tomcat lwrp

### Example

```
tomcat "pentaho" do
  http_port  false
  https_port "8443"
  version    "7"
end
```

To deploy a webapp to the new tomcat, you use a deploy resource or a
maven resource (coming soon).

### Example using JMX

```
tomcat "liferay" do
  user liferay_user
  action :install
  jvm_opts node['liferay']['jvm_opts']
  jmx_opts node['liferay']['jmx_opts']
  jmx_access node['liferay']['jmx_access']
  jmx_password node['liferay']['jmx_password']
end
```


### Clustered configuration

```
tomcat "liferay" do
  user liferay_user
  action :install
  jvm_opts node['liferay']['jvm_opts']
  service_name "liferay-tomcat"
  clustered true
end
```


TODO
====


License and Author
==================

Author:: Bryan W. Berry (<bryan.berry@gmail.com>)

Copyright:: 2012, Bryan W. Berry

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
