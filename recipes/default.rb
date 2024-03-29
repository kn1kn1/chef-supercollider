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

# adduser
newuser = "supercollider"
user "supercollider" do
  username newuser
  password "$6$eMNIaqLd$zfAc3cPc/fvY1gpI/P93Lsu5uMkg0AosO3/bgS6ASxZwGy0i34ppxZLA73EFiGqQ3HOGTnOZSAAaLaUBmdbCk/" # supercollider
  home  "/home/#{newuser}"
  shell "/bin/bash"
  supports :manage_home => true
  action [:create, :manage]
end

# jack
username = newuser
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

# TODO prompt user to reboot with GUI and AUDIO.
# ruby_block "Logging" do
#   block do
#     Chef::Log.warn "Supercollider installation succeeded. Reboot the node with GUI and AUDIO."
#   end
#   action :create
#   not_if "uname -a | grep -q lowlatency"
# end


# execute "reboot" do
#   not_if "uname -a | grep -q lowlatency"
#   command "reboot"
# end
