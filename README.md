Network Checker
===============

Shows detailed informations about your CIDR network
---------------------------------------------------

First of all this is just a little demo project. It generates detailed informations about your CIDR network.


Usage
-----

```ruby
irb> require 'network_checker'
=> true

irb> network = NetworkChecker.new("192.168.1.12/20")
=> #<NetworkChecker:0x007fbd53a9cc30 @address_block="192.168.1.12", @network_block="20">

irb> network.print_network_info
Networkaddress:        192.168.0.0
Network CIDR Notation: 192.168.0.0/20
CIDR Address Range:    192.168.0.1 - 192.168.15.254
Subnet Mask:           255.255.240.0
Wildcard Mask:         0.0.15.255
Broadcast:             192.168.15.255
First Host:            192.168.0.1
Last Host:             192.168.15.254
Maximum Hosts:         4094
=> nil

irb> network.network
=> "192.168.0.0"

irb> network.first_host
=> "192.168.0.1"
```