require 'spec_helper'
require 'serverspec'

package = 'monit'
service = 'monit'
config  = '/etc/monitrc'
config_dir  = '/etc/monit.d'
ports   = [ 2812 ]
script_path = '/usr/sbin'
scripts = %w[ isakmpd_start ]
ssh_rc_command = '/etc/init.d/ssh'

case os[:family]
when 'freebsd'
  config = '/usr/local/etc/monitrc'
  config_dir = '/usr/local/etc/monit.d'
  script_path = '/usr/local/sbin'
  ssh_rc_command = '/etc/rc.d/sshd'
when 'openbsd'
  script_path = '/usr/local/sbin'
  ssh_rc_command = '/etc/rc.d/sshd'
when 'ubuntu'
  config = '/etc/monit/monitrc'
  config_dir = '/etc/monit/monitrc.d'
end

describe package(package) do
  it { should be_installed }
end 

describe file(config) do
  it { should be_file }
  its(:content) { should match /^set daemon \d+\n\s+with start delay \d+/ }
  its(:content) { should match /^set httpd port 2812\n\s+use address #{ Regexp.escape('127.0.0.1') }\n\s+allow\s+#{ Regexp.escape('127.0.0.1') }/ }
  its(:content) { should match /^set logfile syslog facility log_daemon/ }
  its(:content) { should match /^include #{ Regexp.escape(config_dir + '/*') }/ }
end

#case os[:family]
#when 'freebsd'
#  describe file('/etc/rc.conf.d/monit') do
#    it { should be_file }
#  end
#end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

describe file("#{ config_dir }/sshd.monitrc") do
  it { should be_file }
  it { should be_mode 600 }
  its(:content) { should match /#{ Regexp.escape('start program "' + ssh_rc_command + ' start"') }/ }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

scripts.each do |file|
  describe file("#{ script_path }/#{ file }") do
    it { should be_file }
    it { should be_mode 755 }
  end
end
