import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(BetCalculatorApp());
}

class BetCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BetCalculatorScreen(),
    );
  }
}

class BetCalculatorScreen extends StatefulWidget {
  @override
  _BetCalculatorScreenState createState() => _BetCalculatorScreenState();
}

class _BetCalculatorScreenState extends State<BetCalculatorScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController ratioAController = TextEditingController();
  TextEditingController ratioBController = TextEditingController();

  double betA = 0, betB = 0, loss = 0;
  String teamA = "Mumbai Indians";
  String teamB = "Chennai Super Kings";

  final List<String> iplTeams = [
    "Mumbai Indians", "Chennai Super Kings", "Royal Challengers Bangalore", 
    "Kolkata Knight Riders", "Sunrisers Hyderabad", "Delhi Capitals",
    "Punjab Kings", "Rajasthan Royals", "Lucknow Super Giants", "Gujarat Titans"
  ];

  void calculateBets() {
    double totalAmount = double.tryParse(amountController.text) ?? 0;
    double ratioA = double.tryParse(ratioAController.text) ?? 1;
    double ratioB = double.tryParse(ratioBController.text) ?? 1;

    if (totalAmount > 0 && ratioA > 0 && ratioB > 0) {
      setState(() {
        betA = totalAmount / (1 + (ratioA / ratioB));
        betB = totalAmount - betA;
        double potentialWinA = betA * ratioA;
        double potentialWinB = betB * ratioB;
        loss = totalAmount - min(potentialWinA, potentialWinB);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IPL Bet Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Teams", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: teamA,
                  items: iplTeams.map((String team) {
                    return DropdownMenuItem<String>(
                      value: team,
                      child: Text(team),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      teamA = newValue!;
                    });
                  },
                ),
                Text("VS", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: teamB,
                  items: iplTeams.map((String team) {
                    return DropdownMenuItem<String>(
                      value: team,
                      child: Text(team),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      teamB = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total Amount', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ratioAController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '$teamA Odds', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ratioBController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '$teamB Odds', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: calculateBets,
                child: Text('Calculate Bets', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 20),
            Text('Bet on $teamA: \$${betA.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            Text('Bet on $teamB: \$${betB.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
            Text('Possible Loss: \$${loss.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}