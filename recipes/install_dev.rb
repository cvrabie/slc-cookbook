#
# Cookbook Name:: slc
# Recipe:: install_dev
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

include_recipe 'nodejs::nodejs_from_package'
include_recipe 'nodejs::npm'

ver = node['slc']['version']
verfile = '/var/slc.version'

execute 'update npm' do
	command 'npm update -g'
	not_if "grep -Fxq '#{ver}' #{verfile}"
end

nodejs_npm 'strongloop' do
	options ['-g']
	version ver
	notifies :create, "file[#{verfile}]", :immediately
	not_if "grep -Fxq '#{ver}' #{verfile}"
end

file verfile do
	action :nothing
	content ver
end

auth = ''
if node['slc']['http-auth'].strip != ''
	auth = "--http-auth #{node['slc']['http-auth']}"
end

ports = "--port #{node['slc']['port']} --base-port #{node['slc']['base-port']}"

execute 'install pm service' do
	command "slc pm-install --systemd #{ports} #{auth}"
	creates '/etc/systemd/system/strong-pm.service'
	action :run
end	

service 'strong-pm' do
	action [:enable, :start]
end