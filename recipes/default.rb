#
# Cookbook Name:: amazon_ses
# Recipe:: default
#
# Copyright 2011, Dale-Kurt Murray
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

include_recipe "postfix"

cookbook_file "/etc/postfix/master.cf" do
  source "master.cf"
  action :create
end

cookbook_file "/etc/postfix/main.cf" do
  source "main.cf"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :restart, resources(:service => "postfix")
end

%w{amazon amazon/bin}.each do |dir|
   directory "/opt/#{dir}" do
      mode 0775
      owner "root"
      group "root"
      action :create
      recursive true
   end
end

# AWS Credentials
template "/opt/amazon/bin/awscred" do
  source "awscred.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
end

cookbook_file "/opt/amazon/bin/ca-bundle.crt" do
  source "ca-bundle.crt"
  owner "root"
  group "root"
  mode 0644
  action :create
end

cookbook_file "/opt/amazon/bin/ses-get-stats.pl" do
  source "ses-get-stats.pl"
  owner "root"
  group "root"
  mode 0755
  action :create
end

cookbook_file "/opt/amazon/bin/ses-send-email.pl" do
  source "ses-send-email.pl"
  owner "root"
  group "root"
  mode 0755
  action :create
end

cookbook_file "/opt/amazon/bin/ses-verify-email-address.pl" do
  source "ses-verify-email-address.pl"
  owner "root"
  group "root"
  mode 0755
  action :create
end

# Create directory path /usr/local/lib/perl/5.10.1/
%w{perl perl/5.10.1}.each do |dir|
   directory "/usr/local/lib/#{dir}" do
      mode 0775
      owner "root"
      group "root"
      action :create
      recursive true
   end
end

# Update: Relocate to /usr/local/lib/perl/5.10.1/SES.pm
# cookbook_file "/opt/amazon/bin/SES.pm" do
cookbook_file "/usr/local/lib/perl/5.10.1/SES.pm" do
  source "SES.pm"
  owner "root"
  group "root"
  mode 0644
  action :create
end

# Install perl modules
package "libio-socket-ssl-perl" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "libio-socket-ssl-perl"
  else
    action :upgrade
  end
end    
package "libxml-libxml-perl" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "libxml-libxml-perl"
  else
    action :upgrade
  end
end

# Install procmail
package "procmail" do
  case node[:platform]
  when "debian","ubuntu"
    package_name "procmail"
  else
    action :upgrade
  end
end