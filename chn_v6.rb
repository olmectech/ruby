#!/usr/bin/env ruby
#
# This program changes hostname and gerenated new Puppet certificate.
#

require 'yaml'
require 'augeas'

@@config = YAML.load_file("config.yml")

class Host_change

   def change_files
        Augeas.open do |aug|
        aug.set('/files/etc/hosts/3/canonical', "#{@@word}.#{@@dom}")
        aug.set('/files/etc/sysconfig/network/HOSTNAME ', "#{@@word}.#{@@dom}")
        aug.set('/files/etc/hosts/3/alias', "#{@@word}")
        aug.set('/files/etc/sysctl.conf/kernel.hostname', "#{@@word}.#{@@dom}")
        aug.set('/files/etc/puppetlabs/puppet/puppet.conf/agent/certname', "#{@@word}.#{@@dom}")
        aug.save
      end
        puts "Changed hostname to #{@@word}.#{@@dom} in hosts file."
        puts "Changed hostname to #{@@word}.#{@@dom} in sysconfig file."
        puts "Changed hostname to #{@@word}.#{@@dom} in sysctl.conf file."
        puts "Changed hostname to #{@@word}.#{@@dom} in puppet.conf file."
  end

   def run_commands 
      system('find /var/lib/puppet/ssl -type f -print | xargs rm -v')
      %x[sysctl -p]
      %x[puppet agent -t --server #{@@config['puppetmaster']}]
   end
  
   loop do

   system "clear"

      puts " "
      puts "This script changes name of sever and generates new Puppet certificate."
      puts "----------------------------------------------------------------------"
      puts " "

      puts "1) What's the new hostname?"
      @@word = gets.chomp
      puts " "

      puts "2) What's your domain name?(#{@@config['domain']})"
      @@dom = gets.chomp
      puts " "

      puts "3) Is the FQDN hostname #{@@word}.#{@@dom}?(y/n)"
      ans = gets.chomp
      puts " "

   if ans.capitalize == "Y"

     Host_change_obj=Host_change.new
     Host_change_obj.change_files
     puts " "
     Host_change_obj.run_commands

     break

   elsif ans.capitalize == 'N'
       end
  end
end
