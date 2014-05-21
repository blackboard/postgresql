#
# Cookbook Name:: postgresql
# Recipe:: server
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Lamont Granquist (<lamont@opscode.com>)#
# Copyright 2009-2011, Opscode, Inc.
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

include_recipe "postgresql::client"

directory node['postgresql']['dir'] do
  owner "postgres"
  group "postgres"
  recursive true
  action :create
end

node['postgresql']['server']['packages'].each do |pg_pack|

  package pg_pack

end

execute "/usr/lib/postgresql/#{node['postgresql']['version']}/bin/initdb -E UTF8 --locale en_US.UTF-8 -D #{node['postgresql']['dir']}" do
 user 'postgres'
 not_if { ::FileTest.exist?("#{node['postgresql']['dir']}/PG_VERSION") }
end

service "postgresql" do
  service_name node['postgresql']['server']['service_name']
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
