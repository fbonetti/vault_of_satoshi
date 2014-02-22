module VaultOfSatoshi
  module API
    class Base
      include HTTParty
      base_uri 'https://api.vaultofsatoshi.com'

      CRYPTO_CURRENCIES = [:BTC, :LTC, :PPC, :DOGE, :FTC, :XPM, :QRK]
      FIAT_CURRENCIES = [:CAD, :USD]
      ALL_CURRENCIES = CRYPTO_CURRENCIES + FIAT_CURRENCIES

      def initialize(api_key, api_secret)
        @api_key = api_key
        @api_secret = api_secret
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
        data = params.to_param
        Base64.strict_encode64(OpenSSL::HMAC.hexdigest('sha512', @api_secret, endpoint + 0.chr + data))
      end

      def parse_data(data, options = {})
        data = OpenStruct.new(data)

        [*options[:unix_timestamps]].each do |unix_timestamp|
          data[unix_timestamp] = parse_unix_timestamp(data[unix_timestamp])
        end

        [*options[:microsecond_timestamps]].each do |microsecond_timestamp|
          data[microsecond_timestamp] = parse_microsecond_timestamp(data[microsecond_timestamp])
        end

        [*options[:currency_objects]].each do |currency_object|
          data[currency_object] = parse_currency_object(data[currency_object])
        end

        [*options[:booleans]].each do |boolean|
          data[boolean] = parse_boolean(data[boolean])
        end

        data
      end

      def parse_unix_timestamp(seconds_since_epoch)
        DateTime.strptime(seconds_since_epoch.to_s, "%s")
      end

      def parse_microsecond_timestamp(micro_seconds_since_epoch)
        seconds_since_epoch = BigDecimal.new(micro_seconds_since_epoch.to_s) / 1_000_000
        DateTime.strptime(seconds_since_epoch.to_s("F"), "%s")
      end

      def parse_currency_object(object)
        BigDecimal.new(object["value"]).truncate(object["precision"])
      end

      def parse_boolean(int)
        int.to_i == 1
      end

      # Accepts a date_input in the form of a unix timestamp, Date object, or Time object
      def date_input_to_microseconds(date_input)
        DateTime.strptime(date_input.to_f.to_s, '%s').strftime("%s").to_i * 1_000_000
      end

      def generate_currency_object(number)
        precision = 8
        value = sprintf("%0.#{precision}f", number)
        {
          precision: precision,
          value: value,
          value_int: value.gsub('.', '').to_i
        }
      end

    end
  end
end