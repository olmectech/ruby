chn_v6.rb
====

This ruby program changes hostname on Centos 6.x client then generates new Puppet certificate without reboot.
Below are packages needed on client and install instructions.

##Packages needed by client

- $ yum -y groupinstall 'Development Tools' <cr>
- $ yum -y install ruby <cr> v 1.9.3 <cr>
- $ yum -y install gcc ruby-devel rubygems <cr>
- $ yum -y install augeas <cr>
- $ yum -y install augeas-devel <cr>
- $ rpm -i ruby-augeas-0.5.0-0.9999.el6.x86_64.rpm <cr>

##Install puppet agent on client

- $ curl -k https://puppetmaster.dc.rr.com:8140/packages/current/install.bash | sudo bash <cr>

##Run hostname change program. No reboot required.

- $ ./cfn_v5.rv <cr>

##On Puppet Master

- $ puppet cert list <cr>
- $ puppet cert sign <hostname> <cr>

##On client

- $ puppet agent -t <cr>


