import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subsuclib/configs/const_text.dart';
import 'package:subsuclib/models/todo.dart';
import 'package:subsuclib/repositories/todo_bloc.dart';

class TodoEditView extends StatelessWidget {

  final DateFormat _format = DateFormat("yyyy-MM-dd");

  final TodoBloc todoBloc;
  final Subsuc todo;
  final Subsuc _newTodo = Subsuc.newTodo();

  TodoEditView({Key key, @required this.todoBloc, @required this.todo}){
    // Dartでは参照渡しが行われるため、todoをそのまま編集してしまうと、
    // 更新せずにリスト画面に戻ったときも値が更新されてしまうため、
    // 新しいインスタンスを作る
    _newTodo.id = todo.id;
    _newTodo.name = todo.name;
    _newTodo.amount = todo.amount;
    _newTodo.billingPeriod = todo.billingPeriod;
    _newTodo.startDate = todo.startDate;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text("")),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              _titleTextFormField(),
              _noteTextFormField(),
              _billingFormField(),
              _dueDateTimeFormField(),
              _confirmButton(context)
            ],
          ),
        )
    );
  }

  Widget _titleTextFormField() => TextFormField(
    decoration: InputDecoration(labelText: "Name"),
    initialValue: _newTodo.name,
    onChanged: _setTitle,
  );

  void _setTitle(String title) {
    _newTodo.name = title;
  }

  Widget _noteTextFormField() => TextFormField(
    decoration: InputDecoration(labelText: "amount"),
    keyboardType: TextInputType.number,
    initialValue: _newTodo.amount.toString(),
    maxLines: 1,
    onChanged: _setNote,
  );

  void _setNote(String amount) {
    _newTodo.amount = int.parse(amount);
  }


  // StatefulWidget _billingFormField() => DropdownButton<String>(
  //   value: _billingItem,
  //   onChanged: _setBilling,
  //
  //   selectedItemBuilder: (context) {
  //     return _billing.map((String item) {
  //       return Text(
  //         item,
  //         style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold,height: 1.5),
  //       );
  //     }).toList();
  //   },
  //   items: _billing.map((String item) {
  //     return DropdownMenuItem(
  //       value: item,
  //       child: Text(
  //         item,
  //         style: item == _billingItem
  //             ? TextStyle(fontWeight: FontWeight.bold)
  //             : TextStyle(fontWeight: FontWeight.normal),
  //       ),
  //     );
  //   }).toList(),
  // );
  //
  // void _setBilling(String billing) {
  //   _billingItem=billing;
  //   _newTodo.billingPeriod = billing;
  // }



  // ↓ https://pub.dev/packages/datetime_picker_formfield のサンプルから引用
  Widget _dueDateTimeFormField() => DateTimeField(
      format: _format,
      decoration: InputDecoration(labelText: "start"),
      initialValue: _newTodo.startDate ?? DateTime.now(),
      onChanged: _setDueDate,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          // final time = await showTimePicker(
          //   context: context,
          //   initialTime: TimeOfDay.fromDateTime(
          //       currentValue ?? DateTime.now()),
          // );
          return date;
        } else {
          return currentValue;
        }
      }
  );

  void _setDueDate(DateTime dt) {
    _newTodo.startDate = dt;
  }

  Widget _confirmButton(BuildContext context) => RaisedButton.icon(
    icon: Icon(
      Icons.tag_faces,
      color: Colors.white,
    ),
    label: Text("決定"),
    onPressed: () {
      if (_newTodo.id == null) {
        todoBloc.create(_newTodo);
      } else {
        todoBloc.update(_newTodo);
      }

      Navigator.of(context).pop();
    },
    shape: StadiumBorder(),
    color: Colors.green,
    textColor: Colors.white,
  );
}





class _MyInheritedWidget extends InheritedWidget {
  _MyInheritedWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final HomePageState data;

  @override
  bool updateShouldNotify(_MyInheritedWidget oldWidget) {
    return true;
  }
}


class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  HomePageState createState() => HomePageState();

  static HomePageState of(BuildContext context, {bool rebuild = true}) {
    if (rebuild) {
      return (context.inheritFromWidgetOfExactType(_MyInheritedWidget) as _MyInheritedWidget).data;
    }
    return (context.ancestorWidgetOfExactType(_MyInheritedWidget) as _MyInheritedWidget).data;
    // 実は下を使うの方が良い
    // return (context.ancestorInheritedElementForWidgetOfExactType(_MyInheritedWidget).widget as _MyInheritedWidget).data;
  }
}

class HomePageState extends State<HomePage> {
  final List<String> _billing = ['Monthly','Yearly'];
  String _billingItem = "Monthly";

  void _incrementCounter(bullding) {
    setState(() {
      _billingItem = bullding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _MyInheritedWidget(
      data: this,
      child: widget.child,
    );
  }
}


class _billingFormField extends StatelessWidget {
  final List<String> _billing = ['Monthly','Yearly'];
  @override
  Widget build(BuildContext context) {
    final HomePageState state = HomePage.of(context);

    return Center(
      child: Row(
          children: <Widget>[
        // タブ選択の詳細
          DropdownButton<String>(
          value: '${state._billingItem}',
          underline: Container(
            height: 2,
            color: Colors.black,
          ),

          onChanged: (String newValue) {
            state._incrementCounter(newValue);
          },
          selectedItemBuilder: (context) {
            return _billing.map((String item) {
              return Text(
                item,
                style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold,height: 1.5),
              );
            }).toList();
          },
          items: _billing.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: item == '${state._billingItem}'
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : TextStyle(fontWeight: FontWeight.normal),
              ),
            );
          }).toList(),
        ),
      ]
      ),

    );
  }
}