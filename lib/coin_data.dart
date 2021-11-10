import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Map<String, double> _rates = {};

  Future<void> retrieveRates() {
    return Future.wait(cryptoList.map((crypto) => _retrieveCryptoRate(crypto)));
  }

  Future<void> _retrieveCryptoRate(final String crypto) async {
    final Uri uri = Uri.https('rest.coinapi.io', 'v1/exchangerate/$crypto');
    final http.Response response = await http.get(
      uri,
      headers: {'X-CoinAPI-Key': '<REDACTED>'},
    );
    if (response.statusCode < 200 && response.statusCode >= 300) {
      throw (HttpException(
          'Error status ${response.statusCode} requesting $uri'));
    }

    print(response.body);

    final Iterable<dynamic> rates = jsonDecode(response.body)['rates'];
    rates.forEach((assetRate) {
      final String currency = assetRate['asset_id_quote'];
      _rates[_toCryptoCurrency(crypto, currency)] = assetRate['rate'];
    });
  }

  double? getConversion(String crypto, String currency) {
    print(
        'GET CONVERSION $crypto $currency ${_rates[_toCryptoCurrency(crypto, currency)]}');
    return _rates[_toCryptoCurrency(crypto, currency)];
  }

  _toCryptoCurrency(String crypto, String currency) {
    return '$crypto:$currency';
  }
}
