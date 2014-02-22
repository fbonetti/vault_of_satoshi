module VaultOfSatoshi
  module API
    class Trade < Base

      def initialize(api_key, api_secret)
        super
      end

      def place(params = {})
        params.slice!(:type, :order_currency, :units, :payment_currency, :price)
        params[:units] = generate_currency_object(params[:units])
        params[:price] = generate_currency_object(params[:price])
        params.merge!(nonce: nonce)
        endpoint = "/trade/place"

        response = self.class.post(endpoint, body: params.to_param, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_data(response["data"])
      end

      def cancel(params = {})
        params.slice!(:order_id)
        params.merge!(nonce: nonce)
        endpoint = "/trade/cancel"

        response = self.class.post(endpoint, body: params.to_param, headers: headers(endpoint, params)).parsed_response
        raise VaultOfSatoshi::API::Error.new(response["message"]) if response["status"] == "error"

        parse_data(response["data"])
      end

    end
  end
end