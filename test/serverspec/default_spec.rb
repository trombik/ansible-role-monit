require 'spec_helper'
require 'serverspec'

package = 'monit'
service = 'monit'
config  = '/etc/monitrc'
config_dir  = '/etc/monit.d'
ports   = [ 2812 ]

case os[:family]
when 'freebsd'
  config = '/usr/local/etc/monitrc'
end

describe package(package) do
  it { should be_installed }
end 

describe file(config) do
  it { should be_file }
  its(:content) { should match /^set daemon \d+/ }
  its(:content) { should match /^set httpd port 2812\n\s+use address #{ Regexp.escape('127.0.0.1') }\n\s+allow\s+#{ Regexp.escape('127.0.0.1') }/ }
  its(:content) { should match /^set logfile syslog facility log_daemon/ }
end

case os[:family]
when 'freebsd'
  describe file('/etc/rc.conf.d/monit') do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

describe file("#{ config_dir }/sshd.monitrc") do
  it { should be_file }
  it { should be_mode 600 }
  its(:content) { should match /#{ Regexp.escape('start program  "/etc/rc.d/sshd start"') }/ }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
