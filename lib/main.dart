import 'dart:math';

import 'package:calculatorpr2/theme.dart';
import 'package:calculatorpr2/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pr2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final List<String> numbersRows = [
  "⌫",
  '0',
  '.',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9'
];
final List<String> calcColumn = ['=', '+', '-', 'x', '÷'];
final List<String> calcRow = ['lg', '|x|', '^'];

class _MyHomePageState extends State<MyHomePage> {
  String _output = '';

  void _updateOutput(String value) {
    setState(() {
      _output += value;
    });
  }


  void _calculateAbs() {
    setState(() {
      _output = double.parse(_output).abs().toString();
    });
  }
  void _calculateLog() {
    setState(() {
      if (_output.isNotEmpty) {
        final double value = double.parse(_output);
        final double result = log(value) / ln10; // Вычисление логарифма по основанию 10
        _output = result.toString();
      }
    });
  }


  equalPressed() {
    var userInputFC =
        _output.replaceAll("x", "*").replaceAll("÷", "/");
    Parser p = Parser();
    Expression exp = p.parse(userInputFC);
    ContextModel ctx = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, ctx);
    setState(() {
      _output = eval.toString();
    });
  }


  void _backspace() {
    setState(() {
      if (_output.isNotEmpty) {
        _output = _output.substring(0, _output.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                _showInfoDialog(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      _output,
                      textAlign: TextAlign.end,
                      style:
                          Theme.of(context).textTheme.displayLarge?.copyWith(
                                overflow: TextOverflow.clip,
                              ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: SizedBox(
                          width: 280,
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: calcRow.map((text) {
                            return CustomAppButton(
                              onPressed: () {
                                if (text == '|x|') {
                                _calculateAbs();
                                } else if (text == "lg"){
                                  _calculateLog();
                                } else {
                                  _updateOutput(text);
                                }
                              },
                              text: text,
                              backgroundColor: MaterialTheme.lightScheme().outline,
                              minSize: MaterialStateProperty.all(const Size(80, 80)),
                              maxSize: MaterialStateProperty.all(const Size(80, 80)),
                            );
                          }).toList(),
                                              ),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: Wrap(
                          verticalDirection: VerticalDirection.up,
                          spacing: 20,
                          runSpacing: 15,
                          children: numbersRows.map((text) {
                            return (CustomAppButton(
                              onPressed: () {
                                if (text == '⌫') {
                                  _backspace();
                                } else {
                                  _updateOutput(text);
                                }
                              },
                              text: text,
                              minSize:
                                  MaterialStateProperty.all(const Size(80, 80)),
                              maxSize:
                                  MaterialStateProperty.all(const Size(80, 80)),
                            ));
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Column(
                        verticalDirection: VerticalDirection.up,
                        children: calcColumn.map((text) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: (CustomAppButton(
                              onPressed: () {
                                if (text == '=') {
                                  equalPressed();
                                } else {
                                  _updateOutput(text);
                                }
                              },
                              text: text,
                              backgroundColor: Colors.indigoAccent[200],
                              minSize:
                                  MaterialStateProperty.all(const Size(80, 80)),
                              maxSize:
                                  MaterialStateProperty.all(const Size(80, 80)),
                            )),
                          );
                        }).toList()),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _showInfoDialog(BuildContext context) async {
    final String markdownText =
        await rootBundle.loadString('assets/dokumentcalc.md');

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigoAccent,
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                child: MarkdownBody(
              data: markdownText
            )),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}
