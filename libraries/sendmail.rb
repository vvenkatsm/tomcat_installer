module SDMAIL


def send_mail
  mailcmd = 'mail -s \"host deployed with tomcat: #{node} operations@intuit.com\"'
  cmd = Mixlib::ShellOut.new(mailcmd)
  cmd.run_command
  Chef::Log.info cmd.stdout unless cmd.stdout.empty?
  Chef::Log.warn cmd.stderr unless cmd.stderr.empty?
  cmd.status == 0
end

Chef::Recipe.send(:include, SDMAIL)
Chef::Provider.send(:include, SDMAIL)
Chef::Resource.send(:include, SDMAIL)

