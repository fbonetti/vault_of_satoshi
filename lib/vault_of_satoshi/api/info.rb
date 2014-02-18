module VaultOfSatoshi
  module API
    class Info < Base

      def initialize(api_key, api_secret)
        super
      end

      def currency(params = {})
        params.slice!(:currency)
        params.merge!(nonce: nonce)
        endpoint = "/info/currency"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_data!(response["data"])
      end

      # needs to be finished
      def account
        params = {nonce: nonce}
        endpoint = "/info/account"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_data!(response["data"]["trade_fee"], currency_objects: CRYPTO_CURRENCIES)
        parse_data!(response["data"]["monthly_volume"], currency_objects: CRYPTO_CURRENCIES)
        parse_data!(response["data"])
      end

      def balance(params = {})
        params.slice!(:currency)
        params.merge!(nonce: nonce)
        endpoint = "/info/balance"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        if params[:currency]
          parse_currency_object(response["data"])
        else
          parse_data!(response["data"], currency_objects: ALL_CURRENCIES)
        end
      end

      def wallet_address(params = {})
        params.slice!(:currency)
        params.merge!(nonce: nonce)
        endpoint = "/info/wallet_address"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_data!(response["data"])
      end

      def wallet_history(params = {})
        params.slice!(:currency, :count, :after)
        params.merge!(nonce: nonce)
        endpoint = "/info/wallet_history"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_options = {currency_objects: :units}
        response["data"].map do |element|
          parse_data!(response["data"], parse_options)
        end
      end

      def ticker(params = {})
        params.slice!(:order_currency, :payment_currency)
        params.merge!(nonce: nonce)
        endpoint = "/info/ticker"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_options = {
          timestamps: :date,
          currency_objects: [
            :opening_price, :closing_price, :min_price, :max_price,
            :average_price, :units_traded, :volume_1day, :volume_7day
          ]
        }
        parse_data!(response["data"], parse_options)
      end

      def quote(params = {})
        params.slice!(:type, :order_currency, :units, :payment_currency, :price)
        params.merge!(nonce: nonce)
        endpoint = "/info/quote"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_options = {currency_objects: [:rate, :subtotal, :fee, :total]}
        parse_data!(response["data"], parse_options)
      end

      def orderbook(params = {})
        params.slice!(:order_currency, :payment_currency, :group_orders, :round, :count)
        params[:group_orders] = [1, "1", true, nil].include?(params[:group_orders]) ? 1 : 0
        params.merge!(nonce: nonce)
        endpoint = "/info/orderbook"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        response["data"]["bids"].map! do |bid_object|
          parse_data!(bid_object, currency_objects: [:price, :quantity])
        end
        response["data"]["asks"].map! do |ask_object|
          parse_data!(ask_object, currency_objects: [:price, :quantity])
        end
        parse_data!(response["data"], timestamps: :timestamp)
      end

      def orders(params = {})
        params.slice!(:count, :after, :open_only)
        params.merge!(nonce: nonce)
        endpoint = "/info/orders"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_options = {
          timestamps: :date_completed,
          currency_objects: [:units, :units_remaining, :price, :fee, :total]
        }

        response["data"].map do |element|
          parse_data!(element, parse_options)
        end
      end

      def order_detail(params = {})
        params.slice!(:order_id)
        params.merge!(nonce: nonce)
        endpoint = "/info/order_detail"

        response = self.class.post(endpoint, body: params, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_options = {
          timestamps: :transaction_date,
          currency_objects: [:units_traded, :price, :fee, :total]
        }

        response["data"].map do |element|
          parse_data!(element, parse_options)
        end
      end

    end
  end
end