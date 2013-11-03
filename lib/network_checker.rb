class NetworkChecker

  IP_ADDRESS_REGEX = /\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/

  @address_block
  @network_block

  REGEX = {
    :network => /\/.*/,
    :address => /.*\//
  }

  def initialize(value)
    extract(:address, value)
    extract(:network, value)
  end

  def print_network_info
    puts "Networkaddress:        #{network}"
    puts "Network CIDR Notation: #{network_cidr_notation}"
    puts "CIDR Address Range:    #{first_host} - #{last_host}"
    puts "Subnet Mask:           #{subnet_mask}"
    puts "Wildcard Mask:         #{wildcard_mask}"
    puts "Broadcast:             #{broadcast}"
    puts "First Host:            #{first_host}"
    puts "Last Host:             #{last_host}"
    puts "Maximum Hosts:         #{max_hosts}"
  end

  def network_bits
    @network_block.to_i
  end

  def host_bits
    32-network_bits
  end

  def network_cidr_notation
    "#{network}/#{network_bits}"
  end

  def network
    convert_binary_to_decimal(binary_network_address)
  end

  def subnet_mask
    convert_binary_to_decimal(binary_subnet_mask)
  end

  def wildcard_mask
    convert_binary_to_decimal(binary_wildcard_mask)
  end

  def broadcast
    convert_binary_to_decimal(binary_broadcast)
  end

  def first_host
    convert_binary_to_decimal(binary_first_host)
  end

  def last_host
    convert_binary_to_decimal(binary_last_host)
  end

  def max_hosts
    (2 ** host_bits) - 2
  end

private

  def extract(type, value)
    self.instance_variable_set("@#{type}_block", value.scan(REGEX[type]).first.gsub('/',''))
    raise "Input is not valid: #{type}" unless self.send("#{type}_valid?")
  end

  def network_valid?
    return true if /\A\d{1,2}\z/.match(@network_block)
    false
  end

  def address_valid?
    return true if IP_ADDRESS_REGEX.match(@address_block)
    false
  end

  def address_to_binary
    octets = @address_block.split('.').map(&:to_i)
    octets.map{ |num_block| sprintf("%08b", num_block) }.join
  end

  def binary_network_address(value = address_to_binary)
    value[network_bits..32] = ''
    value = value + "0" * host_bits
    value
  end

  def binary_subnet_mask(value = address_to_binary)
    value[0..network_bits] = ''
    value = ("1" * network_bits) + value

    value[network_bits..32] = ''
    value = value + ("0" * host_bits)
    value
  end

  def binary_wildcard_mask(value = address_to_binary)
    value[0..network_bits] = ''
    value = ("0" * network_bits) + value

    value[network_bits..32] = ''
    value = value + ("1" * host_bits)
    value
  end

  def binary_broadcast(value = address_to_binary)
    value[network_bits..32] = ''
    value = value + "1" * host_bits
    value
  end

  def binary_first_host(value = binary_network_address)
    value[31] = '1'
    value
  end

  def binary_last_host(value = binary_broadcast)
    value[31] = '0'
    value
  end

  def convert_binary_to_decimal(value)
    value.scan(/.{8}/).map{|x| x.to_i(2)}.join('.')
  end
end
