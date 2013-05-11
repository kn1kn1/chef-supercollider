#
# Cookbook Name:: supercollider
# Recipe:: default
#
# Copyright 2013, Kenichi Kanai
#

# linux-lowlatency
package "linux-lowlatency" do
  action :install
end

# desktop
package "ubuntu-desktop" do
  action :install
end

# supercollider
apt_repository "supercollider-ppa" do
  uri "http://ppa.launchpad.net/supercollider/ppa/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "FABAEF95"
end

package "supercollider" do
  action :install
end

# jack
username = "vagrant"
home = "/home/#{username}"

jackdrc = "#{home}/.jackdrc"
template "jackdrc" do
  path jackdrc
  source "jackdrc.erb"
  owner username
  group username
  mode 0644
end

["#{home}/.config/", "#{home}/.config/rncbc.org/"].each do |dir|
  directory dir do
    owner username
    group username
    mode 0755
    action :create
  end
end

qjackCtlConf = "#{home}/.config/rncbc.org/QjackCtl.conf"
template "QjackCtl" do
  path qjackCtlConf
  source "QjackCtl.conf.erb"
  owner username
  group username
  mode 0644
end

group "audio" do
  action :modify
  members [ username ]
  append true
end

ruby_block "limitsconf" do
  block do
    file = Chef::Util::FileEdit.new("/etc/security/limits.conf")
    file.insert_line_if_no_match("# jack & supercollider", <<-EOL
# jack & supercollider
@audio -rtprio 99
@audio -memlock 250000
@audio -nice -10
EOL
    )
    file.write_file
  end
  not_if "grep -q '# jack & supercollider' /etc/security/limits.conf"
end

execute "reboot" do
  not_if "uname -a | grep -q lowlatency"
  command "reboot"
end
