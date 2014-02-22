module VaultOfSatoshi
  module API
    class Public < Base

      def initialize
      end

      def ticker(params = {})
        params.slice!(:order_currency, :payment_currency)
        endpoint = "/public/ticker"

        response = self.class.get(endpoint, query: params).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_options = {
          timestamps: :date,
          currency_objects: [
            :opening_price, :closing_price, :min_price, :max_price,
            :average_price, :units_traded, :volume_1day, :volume_7day
          ]
        }
        parse_data(response["data"], parse_options)
      end

      def orderbook(params = {})
        params.slice!(:order_currency, :payment_currency, :group_orders, :round, :count)
        params[:group_orders] = [1, "1", true, nil].include?(params[:group_orders]) ? 1 : 0
        endpoint = "/public/orderbook"

        response = self.class.get(endpoint, query: params).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        response["data"]["bids"].map! do |bid_object|
          parse_data(bid_object, currency_objects: [:price, :quantity])
        end
        response["data"]["asks"].map! do |ask_object|
          parse_data(ask_object, currency_objects: [:price, :quantity])
        end
        parse_data(response["data"], timestamps: :timestamp)
      end

    end
  end
end