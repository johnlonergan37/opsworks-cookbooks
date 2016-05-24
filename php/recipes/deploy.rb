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

  link "#{deploy[:deploy_to]}/current/application/config/config.php" do
    cookbook 'php'
    action :create
    retries 0
    retry_delay 2
    link_type :symbolic
    target_file "#{deploy[:deploy_to]}/shared/config/config.php"
  end

  directory "#{deploy[:deploy_to]}/current/application/logs/" do
    recursive true
    mode 0775
    owner "deploy"
    group "apache"
    action :create
  end

end