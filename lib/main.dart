import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(Bai07());

class Bai07 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Máy tính bỏ túi đơn giản',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Máy tính bỏ túi đơn giản'),
        ),
        backgroundColor: Colors.white,
        body: Bai07Home(),
      ),
    );
  }
}

class Bai07Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Bai07CalHomeState();
  }
}

class Bai07CalHomeState extends State<Bai07Home> {
  List<String> lsKeys = [
    'C',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '--',
    '1',
    '2',
    '3',
    '+',
    'ANS',
    '0',
    '.',
    '=',
  ];
  String checkE = '..';
  bool _CheckFunctionKey(index) {
    switch (index) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 7:
      case 11:
      case 15:
      case 19:
        return true;
    }
    return false;
  }

  void _KeyTap(int index) {
    setState(() {});
    switch (index) {
      case 0: //Phím C
        {
          _input = '';
          _result = '0';
        }
        break;
      case 1: //Phím DEL
        {
          // ignore: prefer_is_empty
          if (_input.length > 0) {
            _input = _input.substring(0, _input.length - 1);
          }
        }
        break;
      case 11: //Phím -,do nhãn hiển thị --
        {
          _input += '-';
        }
        break;
      case 16: //Phím Ans,lấy kết quả đưa vào biểu thức tính
        {
          _input = _result;
        }
        break;
      case 19: //Phím =,tính toán giá trị biểu thức
        {
          calculate();
        }
        break;
      default: //các phím số,+,x,/,.
        {
          _input += lsKeys[index];
        }
        break;
    }
  }

  Widget buildKey(int index) {
    return OutlinedButton(
      onPressed: () => _KeyTap(index),
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: lsKeys[index] == '='
            ? Colors.orange.shade100
            : Colors.grey.shade300,
      ),
      child: Text(
        lsKeys[index],
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color:
              _CheckFunctionKey(index) ? Colors.blue.shade900 : Colors.black54,
        ),
      ),
    );
  }

  void checkError() {
    bool check = _input.contains(checkE, 0);
    if (check == true) {
      _result = 'ERROR';
    }
  }

  void calculate() {
    checkError();
    //thay thế các phép x thành *,% thành /100
    String strInput = _input.replaceAll('x', '*');
    strInput = strInput.replaceAll('%', '/100');
    //parse chuỗi nhập sang tính toán biểu thức
    Parser p = Parser();
    Expression exp = p.parse(strInput);
    //tạo model để tính toán biểu thức
    ContextModel conmod = ContextModel();
    double value = exp.evaluate(EvaluationType.REAL, conmod);
    _result = value.toString();
  }

  late String _input;
  late String _result;
  @override
  void initState() {
    super.initState();
    _input = '';
    _result = '0';
  }

  @override
  Widget build(BuildContext context) {
    Widget _TextSection = Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Color.fromARGB(255, 174, 157, 3),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: Text(
              _input,
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 34, 255, 0),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: Text(
              _result,
              style: const TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 245, 57, 5),
              ),
            ),
          ),
        ],
      ),
    );
    Widget _KeySection = Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GridView.builder(
        itemCount: 20,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 15, mainAxisSpacing: 5),
        itemBuilder: ((context, index) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: buildKey(index),
            ),
          );
        }),
      ),
    );
    return Column(
      children: [
        _TextSection,
        Expanded(child: _KeySection),
      ],
    );
  }
}
