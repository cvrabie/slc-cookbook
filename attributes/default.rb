#
# Cookbook Name:: slc
# Recipe:: default
#
# Copyright (c) 2016 Cristian Vrabie
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['slc']['version'] = '6.0.0'
default['slc']['base-port'] = 3000
default['slc']['port'] = 8701
default['slc']['http-auth'] = ''

case node['platform']
when 'amazon'
  default['slc']['service-provider'] = Chef::Provider::Service::Upstart
  default['slc']['service-type'] = '--upstart 0.6'
  default['slc']['service-file'] = '/etc/init/strong-pm.conf'
when 'redhat', 'centos', 'fedora'
  default['slc']['service-provider'] = Chef::Provider::Service::Systemd
  default['slc']['service-type'] = '--systemd'
  default['slc']['service-file'] = '/etc/systemd/system/strong-pm.service'
when 'debian', 'ubuntu'
  default['slc']['service-provider'] = Chef::Provider::Service::Upstart
  default['slc']['service-type'] = '--upstart 1.4'
  default['slc']['service-file'] = '/etc/init/strong-pm.conf'
end