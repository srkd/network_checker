require 'spec_helper'

describe NetworkChecker, "basic functionality" do
  let(:network) { NetworkChecker.new("192.168.1.234/12") }

  context "instance errors" do
    it { lambda{ NetworkChecker.new("192.168.1.234/12a")}.should raise_error "Input is not valid: network" }
    it { lambda{ NetworkChecker.new("abc192.168.1.234/12")}.should raise_error "Input is not valid: address" }
  end

  context "attributes" do
    it { expect(network.instance_variable_get(:@unknown_attribute)).to eq(nil) }
    it { expect(network.instance_variable_get(:@address_block)).to match "192.168.1.234" }
    it { expect(network.instance_variable_get(:@network_block)).to match "12" }
  end

  context "methods" do
    it { expect(network.host_bits).to eq(20) }
    it { expect(network.host_bits).to eq(20) }
    it { expect(network.network_bits).to eq(12) }
    it { expect(network.network).to match "192.160.0.0" }
    it { expect(network.subnet_mask).to match "255.240.0.0" }
    it { expect(network.broadcast).to match "192.175.255.255" }
    it { expect(network.wildcard_mask).to match "0.15.255.255" }
    it { expect(network.network_cidr_notation).to match "192.160.0.0/12" }
    it { expect(network.max_hosts).to eq(1048574) }
    it { expect(network.first_host).to match "192.160.0.1" }
    it { expect(network.last_host).to match "192.175.255.254" }
  end
end