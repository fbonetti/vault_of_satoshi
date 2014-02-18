module VaultOfSatoshi
  module API
    class Client
      attr_reader :public, :info, :trade

      def initialize(api_key, api_secret)
        api_key = "653669f940abbed6222c5cd60cb97f55c5bbc5e57308917d5d8b0c3b13a87f1b"
        api_secret = "e43e3a9f9ef8c27d7c1f07503efdd8468502f6b0173f1f3b97732cd3d9172952"

        @public = VaultOfSatoshi::API::Public.new
        @info = VaultOfSatoshi::API::Info.new(api_key, api_secret)
        @trade = VaultOfSatoshi::API::Trade.new(api_key, api_secret)
      end

      def inspect
        "#<#{self.class}:#{self.object_id}"
      end

    end
  end
end