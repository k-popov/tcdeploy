# Prepare a temporary directory
require 'tmpdir'
deploy_tmp_dir = Dir.mktmpdir
File::chmod(0777, deploy_tmp_dir)

# download the application .war file to temporary directory
remote_file "#{deploy_tmp_dir}/#{node[:tcdeploy][:app_name]}.war" do
    source node[:tcdeploy][:app_download_url]
    mode "0755"
end


# check if context contains '/' at the begining
context = node[:tcdeploy][:app_context].match(/^\//) ? node[:tcdeploy][:app_context] : "/#{node[:tcdeploy][:app_context]}"
# prepare the deployment URL
deploy_url = node[:tcdeploy][:tomcat_manager_url] + \
             "/deploy?path=" + context + \
             "&war=file:" + deploy_tmp_dir + "/" + \
              node[:tcdeploy][:app_name] + ".war"
# prepare the auth header
manager_basic_auth = Base64.encode64("#{node[:tcdeploy][:tomcat_manager_user]}:#{node[:tcdeploy][:tomcat_manager_password]}")

Chef::Log.info("Deploying the app with URL: #{deploy_url}")

# deploy the application

# Chef 0.8.16 doesn't support 'headers" parameter in http_request resource
# This is why I have to use ruby_block

ruby_block "Deploy_apptication_with_manager" do
    block do
        retry_count = 0
        max_retries = 10
        begin
            # wait for the server to get ready
            sleep(1)
            open(deploy_url, "Authorization" => "Basic #{manager_basic_auth}") do |depl|
                depl.each_line do |resp_line|
                    Chef::Log.info("Deploy result is #{resp_line}")
                end
            end
            # exit the loop if the request was successfull
            retry_count = 777
        rescue
            retry_count += 1
            Chef::Log.debug("Failed to connect to Tomcat manager. Retrying")
        end while retry_count < max_retries
    end
    action :create
end

# perform some cleanup
directory "#{deploy_tmp_dir}" do
    action :delete
    recursive true
end
