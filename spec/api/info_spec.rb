require 'spec_helper'

describe VaultOfSatoshi::API::Info do

  let(:api_client) { VaultOfSatoshi::API::Client.new(File.read("./api_key.txt"), File.read("./api_secret.txt")) }

  describe "#currency" do
    it "should return a list of currencies when no params are provided" do
      data = api_client.info.currency
      data.map(&:code).sort.should == VaultOfSatoshi::API::Base::ALL_CURRENCIES.map(&:to_s).sort
      data.detect { |x| x.code == "BTC" }.virtual.should == true
    end

    it "should return one currency when the currency param is provided" do
      data = api_client.info.currency(currency: "BTC")
      data.code.should == "BTC"
    end
  end

  describe "#account" do
    it "should return the expected fields" do
      data = api_client.info.account
      data.to_h.keys.should include(:created, :account_id, :trade_fee, :monthly_volume, :wallets)
    end
  end

end