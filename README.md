## Getting started

### Installation
  
```ruby
gem install 'vault_of_satoshi'
```

### Some notes about this library

* All responses are returned as `OpenStructs` or `Arrays` of `OpenStructs`, meaning that individual members can be accessed by "dot" syntax or as keys of a `Hash`. For example, `response.date` and `response[:date]` are both valid ways to access the `date` member.
* The raw API returns `Currency Objects` to represent prices and quantities. This library automatically converts `Currency Objects` into `BigDecimal` in order to retain precision and abstract away the work of converting `Currency Objects` into usable numerical values.
* For endpoints that require a `Currency Object` as one of the parameters, just use an `Integer`, `Float`, or `BigDecimal`. The library will take care of the rest.

### Setup

```ruby
api_key = "XXXXXXXXXXXXXXXXXXXXXX"
api_secret = "XXXXXXXXXXXXXXXXXXXXXX"
@client = VaultOfSatoshi::API::Client.new(api_key, api_secret)
```

## Examples

### Currency

```ruby
currency = @client.info.currency(currency: 'DOGE')

currency.name
=> "Dogecoin"

currency.virtual
=> true

currency.tradeable
=> true

```

### Account

```ruby
account = @client.info.account

account.created
=> Sat, 01 Feb 2014 03:06:49 +0000

account.trade_fee.DOGE.to_f
=> 0.01

account.wallets.DOGE.daily_withdrawal_limit.to_f
=> 0.0
```

### Balance

```ruby
@client.info.balance.DOGE.to_f
=> 50.0
```

### Wallet Address

```ruby
@client.info.wallet_address(currency: 'DOGE').wallet_address
=> "DD7WjShc937XEmRbGzrCvxjAFAWKwMb9fi"
```

### Wallet History

```ruby
@client.info.wallet_history(currency: 'DOGE').map(&:transfer_date)
=> [Thu, 20 Feb 2014 01:17:35 +0000, Sat, 22 Feb 2014 15:26:09 -0600]
```

### Ticker

```ruby
ticker = @client.info.ticker(order_currency: 'DOGE', payment_currency: 'USD')

ticker.date
=> Sat, 22 Feb 2014 03:57:50 +0000 

ticker.min_price.to_f
=> 0.00118

ticker.average_price.to_f
=> 0.00126

ticker.max_price.to_f
=> 0.00132
```

### Quote

```ruby
quote = @client.info.quote(type: 'bid', order_currency: 'DOGE', units: 1000, payment_currency: 'USD', price: 0.0012)

quote.rate.to_f
=> 0.01

quote.fee.to_f
=> 0.012

quote.subtotal.to_f
=> 1.2

quote.total.to_f
=> 1.212
```

### Orderbook

```ruby
orderbook = @client.info.orderbook(order_currency: 'DOGE', payment_currency: 'USD', round: 8, count: 10)

output = "Price      | Quantity  \n"
output += "-----------------------\n"
orderbook.asks.each do |ask|
  output += sprintf("%0.8f", ask.price)
  output += " | "
  output += sprintf("%0.1f", ask.quantity).rjust(10)
  output += "\n"
end

puts output

Price      | Quantity  
-----------------------
0.00131000 |     2618.0
0.00132000 |    20999.9
0.00132000 |    20000.0
0.00132000 |     1324.2
0.00133000 |    60000.0
0.00133000 |      100.0
0.00133000 |    56000.0
0.00134000 |   380000.0
0.00135000 |   988320.0
0.00137000 |   697000.0
```

### Orders

```ruby
first_order = @client.info.orders.first

first_order.status
=> "filled"

first_order.order_id
=> 540664
```

### Order Detail

```ruby
@client.info.order_detail(order_id: 540664).first.units_traded.to_f
=> 50.0
```

### Place a Trade

```ruby
order = @client.trade.place(type: 'bid', order_currency: 'DOGE', units: 5, payment_currency: 'USD', price: 0.0010)

order.order_id
=> 594853
```

### Cancel a Trade

```ruby
@client.trade.cancel(order_id: 594853)
```

## Donations

If you find this library useful, considering sending a donation! My Dogecoin address is `DD7WjShc937XEmRbGzrCvxjAFAWKwMb9fi`.