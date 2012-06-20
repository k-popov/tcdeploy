maintainer        "Grid Dynamics"
maintainer_email  "clou4dev@griddynamics.com"
description       "Deploys an application to Apache Tomcat"
version           "0.1"

%w{redhat centos debian ubuntu}.each do |os|
  supports os
end

