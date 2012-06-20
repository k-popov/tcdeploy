# URL to download the application .war file from
default[:tcdeploy][:app_download_url] = "http://example.com/my_app.war"
# name of the application
default[:tcdeploy][:app_name] = node[:tcdeploy][:app_download_url].split('/')[-1].gsub(/\.war$/,'')
# application context. Default is application file name.
# (i.e. if node[:tcdeploy][:app_context] = "/myapp"
# the application will be available at http://server.com:8080/myapp )
default[:tcdeploy][:app_context] = "/#{node[:tcdeploy][:app_name]}"


# URL of tomcat web-manager
default[:tcdeploy][:tomcat_manager_url] = "http://localhost:8080/manager"
default[:tcdeploy][:tomcat_manager_user] = "tc-admin"
default[:tcdeploy][:tomcat_manager_password] = "nimda-ct"
