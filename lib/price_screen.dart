import 'dart:io' as io show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Map<String, Map<String, String>> exchangeRate = {};
  String? selectedCurrency = currenciesList.first;

  @override
  void initState() {
    super.initState();
    CoinData coinData = CoinData();
    coinData.retrieveRates().then((value) {
      print('HERE');
      setState(() {
        cryptoList.forEach((crypto) {
          final Map<String, String> cryptoExchangeRate = {};
          exchangeRate[crypto] = cryptoExchangeRate;
          currenciesList.forEach((currency) {
            cryptoExchangeRate[currency] =
                coinData.getConversion(crypto, currency)?.toStringAsFixed(4) ??
                    '?';
          });
        });
      });
    });
  }

  DropdownButton<String> getDropdownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currenciesList
          .map((currency) =>
              DropdownMenuItem(child: Text(currency), value: currency))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: currenciesList.map((currency) => Text(currency)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoList
                .map((crypto) => Padding(
                      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                      child: Card(
                        color: Colors.lightBlueAccent,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 28.0),
                          child: Text(
                            '1 $crypto = ${exchangeRate[crypto]?[selectedCurrency]} $selectedCurrency',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                io.Platform.isIOS ? getCupertinoPicker() : getDropdownButton(),
          ),
        ],
      ),
    );
  }
}

// DropdownButton<String>(
// value: selectedCurrency,
// items: currenciesList
//     .map((currency) =>
// DropdownMenuItem(child: Text(currency), value: currency))
// .toList(),
// onChanged: (value) {
// setState(() {
// selectedCurrency = value;
// });
// },
// ),
