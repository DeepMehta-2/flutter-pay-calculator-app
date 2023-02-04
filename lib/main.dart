import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pay Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final payHoursController = TextEditingController();
  final payRateController = TextEditingController();
  double regularPay = 0;
  double overtimePay = 0;
  double totalPay = 0;
  double tax = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    payHoursController.dispose();
    payRateController.dispose();
    super.dispose();
  }

// Pay calculate logic
  void _calculate() {
    setState(() {
      var hours = double.parse(payHoursController.text);
      var payRate = double.parse(payRateController.text);
      // Less than or equles to 40 hours means regular pay.
      if (hours <= 40) {
        regularPay = hours * payRate;
        totalPay = regularPay;
        overtimePay = 0;
      } else {
        // More than 40 hours counted as overtime pay.
        regularPay = 40 * payRate;
        totalPay = ((hours - 40) * payRate * 1.5 + 40 * payRate);
        overtimePay = (hours - 40) * payRate * 1.5;
      }
      tax = totalPay * 0.18;
    });
  }

  // Show the dialof for text field validation.
  showAlertDialog(BuildContext context, String errorMsg) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(errorMsg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      // color: Colors.grey[100],
      // margin: const EdgeInsets.all(15),
      child: Column(children: [
        Container(
          margin: const EdgeInsets.all(11),
          decoration: const BoxDecoration(color: Colors.grey),
          child: Column(children: [hoursAndrate(), calculate(), result()]),
        ),
        Container(
          height: 120,
          margin: const EdgeInsets.all(11),
          decoration: const BoxDecoration(color: Colors.orange),
          child: Align(
            alignment: Alignment.center,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Deep Mehta',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    '301212407',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ]),
          ),
        )
      ]),
    );
  }

  // Text feild widget
  Widget hoursAndrate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15, 25, 15, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: TextField(
            controller: payHoursController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Number of hours'),
            keyboardType: TextInputType.number,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            //borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
              controller: payRateController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Hourly rate'),
              keyboardType: TextInputType.number),
        )
      ],
    );
  }

  // calculate button widget
  Widget calculate() {
    return Container(
      width: 135,
      margin: const EdgeInsets.all(15),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(15),
          foregroundColor: Colors.black,
          backgroundColor: Colors.blue, // foreground
        ),
        onPressed: () {
          // Validate the value. If value is null than
          if (payHoursController.text.isEmpty ||
              payRateController.text.isEmpty) {
            showAlertDialog(context, "Values cannot be empty!!!");
            return;
          } else if (int.parse(payHoursController.text) <= 0 ||
              int.parse(payRateController.text) <= 0) {
            // Validate value for 0 or less than 0 value.
            showAlertDialog(context, "Values cannot be 0 or less than 0 !!!");
            return;
          }
          FocusManager.instance.primaryFocus
              ?.unfocus(); // Hide the keyboard when user click on calculate button.
          _calculate();
        },
        child: const Text(
          'Calculate',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Result widget
  Widget result() {
    return Container(
      height: 200,
      width: 500,
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 35),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Report',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            Row(
              children: [
                const Text(
                  'Regular pay :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$regularPay',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Overtime pay :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$overtimePay',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Total pay :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$totalPay',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Tax :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$tax',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            )
          ]),
    );
  }
}
