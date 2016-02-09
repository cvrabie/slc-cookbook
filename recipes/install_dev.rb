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


ver = node['slc']['version']
service_type = node['slc']['service-type']
verfile = '/var/slc.version'

directory '/root/.node-gyp' do
	action :create
	owner 'root'
	group 'root'
	mode '700'
end

directory '/root/.node-gyp/4.2.6' do
	action :create
	owner 'root'
	group 'root'
	mode '744'
end

execute 'install node-gyp' do
	command 'npm install -g node-gyp'
	user 'root'
	group 'root'
	not_if "grep -Fxq '#{ver}' #{verfile}"
end

execute 'install strongloop' do
	command 'npm install -g strongloop'
	user 'root'
	group 'root'
	not_if "grep -Fxq '#{ver}' #{verfile}"
end

auth = ''
if node['slc']['http-auth'].strip != ''
	auth = "--http-auth #{node['slc']['http-auth']}"
end

ports = "--port #{node['slc']['port']} --base-port #{node['slc']['base-port']}"

execute 'install pm service' do
	command "slc pm-install #{service_type} #{ports} #{auth}" #install using upstart
	creates node['slc']['service-file']
	action :run
end	

service 'strong-pm' do
  	provider node['slc']['service-provider']
  	notifies :create, "file[#{verfile}]", :immediately
	action [:enable, :start]
end

file verfile do
	action :nothing
	content ver
end