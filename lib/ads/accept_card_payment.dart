/* //@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_rave/flutter_rave.dart';

class AcceptCardPayment extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.orangeAccent,
      theme: ThemeData(primaryColor: Colors.orangeAccent),
      title: 'Flutterwave',
      debugShowCheckedModeBanner: false,
      home: CardPayment(title: 'Flutterwave'),
    );
  }
}

class CardPayment extends StatefulWidget {
  CardPayment({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: InkWell(
                onTap: () => _pay(context),
                child: Card(
                  color: Colors.orangeAccent,
                  elevation: 15,
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Card Payment",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.payment,
                            color: Colors.black,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pay(BuildContext context) {
    final snackBar_onFailure = SnackBar(content: Text('Transaction failed'));
    final snackBar_onClosed = SnackBar(content: Text('Transaction closed'));
    final _rave = RaveCardPayment(
      isDemo: true,
      encKey: "700277ea0137f5e3111bfe52",
      publicKey: "FLWPUBK-51bd4461918c4511b6fb4b8ceefb0c1e-X",
      transactionRef: "hvHPvKYaRuJLlJWSPWGGKUyaAfWeZKnm",
      amount: 100,
      email: "demo1@example.com",
      onSuccess: (response) {
        print("$response");
        print("Transaction Successful");
        if (mounted) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Transaction Sucessful!"),
              backgroundColor: Colors.green,
              duration: Duration(
                seconds: 5,
              ),
            ),
          );
        }
      },
      onFailure: (err) {
        print("$err");
        print("Transaction failed");
        Scaffold.of(context).showSnackBar(snackBar_onFailure);
      },
      onClosed: () {
        print("Transaction closed");
        Scaffold.of(context).showSnackBar(snackBar_onClosed);
      },
      context: context,
    );
    _rave.process();
  }
}
 */
