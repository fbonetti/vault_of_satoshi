module VaultOfSatoshi
  module API
    class Client
      attr_reader :public, :info, :trade

      def initialize(api_key, api_secret)
        @public = VaultOfSatoshi::API::Public.new
        @info = VaultOfSatoshi::API::Info.new(api_key, api_secret)
        @trade = VaultOfSatoshi::API::Trade.new(api_key, api_secret)
      end

      def inspect
        "#<#{self.class}:#{self.object_id}>"
      end

    end
  end
end