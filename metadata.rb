name 'slc'
maintainer 'Cristian Vrabie'
maintainer_email 'cristian.vrabie@gmail.com'
license 'Apache 2.0'
description 'Installs SLC and provides resources to configure services'
version '0.1.0'

%w{ ubuntu debian redhat centos fedora amazon }.each do |os|
  supports os
end

depends 'nodejs', '~> 2.4.4'