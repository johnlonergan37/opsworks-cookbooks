node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping php::configure application #{application} as it is not an PHP app")
    next
  end

  # write out opsworks.php
  template "#{deploy[:deploy_to]}/shared/config/opsworks.php" do
    cookbook 'php'
    source 'opsworks.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :database => deploy[:database],
      :memcached => deploy[:memcached],
      :layers => node[:opsworks][:layers],
      :stack_name => node[:opsworks][:stack][:name]
    )
    
  end

  # write out opsworks.php
  template "#{deploy[:deploy_to]}/shared/config/database.php" do
    cookbook 'php'
    source 'database.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :database => deploy[:database],
      :memcached => deploy[:memcached],
      :layers => node[:opsworks][:layers],
      :stack_name => node[:opsworks][:stack][:name]
    )
  end

    # write out opsworks.php
  template "#{deploy[:deploy_to]}/shared/config/config.php" do
    cookbook 'php'
    source 'config.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :lb_hostname => deploy[:lb_hostname],
      :encryption_key => deploy[:encryption_key]
    )
    
  end
end
