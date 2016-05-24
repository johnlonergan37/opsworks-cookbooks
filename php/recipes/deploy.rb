node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping php::configure application #{application} as it is not an PHP app")
    next
  end

        # write out index.php
  template "#{deploy[:deploy_to]}/current/index.php" do
    cookbook 'php'
    source 'index.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]

    variables(
        :environment => node[:deploy][:ci_config][:environment]
        )
  end

  # write out opsworks.php
  template "#{deploy[:deploy_to]}/current/application/config/database.php" do
    cookbook 'php'
    source 'database.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
        :db_host => node[:deploy][:ci_config][:db_host],
        :db_username => node[:deploy][:ci_config][:db_username],
        :db_password => node[:deploy][:ci_config][:db_password],
        :db_name => node[:deploy][:ci_config][:db_name],
        :ro_db_host => node[:deploy][:ci_config][:ro_db_host],
        :ro_db_username => node[:deploy][:ci_config][:ro_db_username],
        :ro_db_password => node[:deploy][:ci_config][:ro_db_password],
        :ro_db_name => node[:deploy][:ci_config][:ro_db_name]
    )
  end

    # write out opsworks.php
  template "#{deploy[:deploy_to]}/current/application/config/config.php" do
    cookbook 'php'
    source 'config.php.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :encryption_key => node[:deploy][:ci_config][:encryption_key],
      :lb_hostname => node[:deploy][:ci_config][:lb_hostname],
      :lb_protocol => node[:deploy][:ci_config][:lb_protocol],
      :rodb_on => node[:deploy][:ci_config][:rodb_on], 
      :ruby_api_url => node[:deploy][:ci_config][:ruby_api_url]
    )
    
  end

  directory "#{deploy[:deploy_to]}/current/application/logs/" do
    recursive true
    mode 0775
    owner "deploy"
    group "apache"
    action :create
  end

end