module VaultOfSatoshi
  module API
    class Base
      include HTTParty
      base_uri 'https://api.vaultofsatoshi.com'

      CRYPTO_CURRENCIES = [:BTC, :LTC, :PPC, :DOGE, :FTC, :XPM, :QRK]
      FIAT_CURRENCIES = [:CAD, :USD]
      ALL_CURRENCIES = CRYPTO_CURRENCIES + FIAT_CURRENCIES

      def initialize(api_key, api_secret)
        @api_key = "653669f940abbed6222c5cd60cb97f55c5bbc5e57308917d5d8b0c3b13a87f1b"
        @api_secret = "e43e3a9f9ef8c27d7c1f07503efdd8468502f6b0173f1f3b97732cd3d9172952"
      end

      def inspect
        "#<#{self.class}:#{self.object_id}>"
      end

      private

      def nonce
        sprintf("%0.6f", Time.now.to_f).gsub('.', '')
      end

      def headers(endpoint, params)
        {
          "Api-Key"  => @api_key,
          "Api-Sign" => generate_api_sign(endpoint, params)
        }
      end

      def generate_api_sign(endpoint, params)
        data = URI.encode_www_form(params)
        Base64.strict_encode64(OpenSSL::HMAC.hexdigest('sha512', @api_secret, endpoint + 0.chr + data))
      end

      def parse_data!(data, options = {})
        data = OpenStruct.new(data)

        [*options[:timestamps]].each do |timestamp|
          data[timestamp] = parse_unix_timestamp(data[timestamp])
        end

        [*options[:currency_objects]].each do |currency_object|
          data[currency_object] = parse_currency_object(data[currency_object])
        end

        data
      end

      def parse_unix_timestamp(timestamp)
        DateTime.strptime(timestamp.to_s, "%s")
      end

      def parse_currency_object(object)
        #BigDecimal.new(object["value"]).round(object["precision"])
        object["value"].to_f.round(object["precision"].to_i)
      end

      def generate_currency_object(number)
        precision = 8
        number = number.kind_of?(Float) ? BigDecimal.new(number.to_s) : BigDecimal.new(number)
        value = sprintf("%0.8#{precision}f", number)

        {
          precision: precision,
          value: value,
          value_int: value.gsub('.', '')
        }
      end

    end
  end
end