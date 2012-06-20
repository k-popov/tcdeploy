# Prepare a temporary directory
require 'tmpdir'
deploy_tmp_dir = Dir.mktmpdir
File::chmod(0777, setup_tmp_dir)

# download the application .war file to temporary directory
remote_file "#{deploy_tmp_dir}/#{node[:tcdeploy][:app_name]}.war" do
    source node[:tcdeploy][:app_download_url]
    mode "0755"
end

# prepare the deployment URL
deploy_url = node[:tcdeploy][:tomcat_manager_url] + \
             "/deploy?path=" + node[:tcdeploy][:app_context] + \
             "&war=file:" + deploy_tmp_dir + "/" + \
              node[:tcdeploy][:app_name] + ".war"
# prepare the auth header
manager_basic_auth = Base64.encode64("#{node[:tcdeploy][:tomcat_manager_user]}:#{node[:tcdeploy][:tomcat_manager_password]}")

Chef::log.debug("Deploying the app with URL: #{deploy_url}")

# deploy the application
http_request "Deploy_apptication_with_manager" do
    url deploy_url
    action :get
    headers( {"Authorization" => "Basic #{manager_basic_auth}"} )
    message ""
end

# perform some cleanup
directory "#{deploy_tmp_dir}" do
    action :delete
    recursive true
end
