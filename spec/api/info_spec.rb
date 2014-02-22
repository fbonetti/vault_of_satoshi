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

  describe "#balance" do
    it "should return the expected fields" do
      data = api_client.info.balance(currency: 'BTC')
      data.should be_kind_of(BigDecimal)
    end
  end

  describe "#wallet_address" do
    it "should return the expected fields" do
      data = api_client.info.wallet_address(currency: 'BTC')
      data.to_h.keys.should include(:wallet_address, :currency)
    end
  end

  describe "#ticker" do
    it "should return the expected fields" do
      data = api_client.info.ticker(order_currency: 'BTC', payment_currency: 'USD')
      data.to_h.keys.should include(
        :date, :opening_price, :closing_price, :min_price, :max_price, 
        :average_price, :units_traded, :volume_1day, :volume_7day
      )
    end
  end

  describe "#quote" do
    it "should return the expected fields" do
      data = api_client.info.quote(type: 'bid', order_currency: 'BTC', units: 1, payment_currency: 'USD', price: 10.0)
      data.to_h.keys.should include(:rate, :subtotal, :fee, :total)
    end
  end

  describe "#orderbook" do
    it "should return the expected fields" do
      data = api_client.info.orderbook(order_currency: 'BTC', payment_currency: 'USD')
      data.to_h.keys.should include(:timestamp, :order_currency, :payment_currency, :bids, :asks)
    end
  end

end