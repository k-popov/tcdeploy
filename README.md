tcdeploy
========

Cookbook to deploy a java application to Apache Tomcat

Sample JSON file:
This will also install tomcat6 with apache httpd proxy before deploying the application
{   
    "tomcat6": {
        "install_java": false,
        "config_dir": "/usr/local/etc/tomcat",
        "user": "tomcat",
        "group": "tomcat",
        "apache_proxy" : true
    },
    "tcdeploy": {
        "app_download_url": "http://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war",
        "app_name": "app",
        "app_context": "ROOT",
        "install_tomcat6": true
    },
    "apache": {
        "default_proxy": {
            "read_thru_locations": {
                "logs": false,
                "conf": false
                },
            "ssl_offload": true
            },
            "port": 80,
            "port_secure": 443,
            ":proxy_port": 8080,
            "https_enabled": true,
            "https_forward": false
    },
    "run_list": [
        "java6",
        "tcdeploy"
    ]
}
