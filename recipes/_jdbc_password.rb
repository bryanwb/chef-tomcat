ruby_block "get jdbc password" do
  block do
    app_name = node['tomcat']['application']
    app_env = node['app_env']
    bag, item = node['passwd_data_bag'].split('/')
    db = Chef::EncryptedDataBagItem.load(bag, item)
    node['tomcat']['jdbc']['password'] = db[app_name][app_env]['jdbc']
  end
end
