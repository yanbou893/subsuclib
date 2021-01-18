import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuclib/components/todo_edit/todo_edit_view.dart';
import 'package:subsuclib/configs/const_text.dart';
import 'package:subsuclib/models/todo.dart';
import 'package:subsuclib/repositories/todo_bloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;

  final List<Tab> tabs = <Tab>[
    // Tab(
    //   text: ConstText.appTitle,
    // ),
    Tab(
      text: "Monthly",
    ),
    Tab(
      text: "Yearly",
    )
  ];
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    var maxHeight = size.height - padding.top - padding.bottom;

    // アプリ描画エリアの縦サイズを取得
    if (Platform.isAndroid) {
      maxHeight = size.height - padding.top - kToolbarHeight;
    } else if (Platform.isIOS) {
      maxHeight = size.height - padding.top - padding.bottom - 22;
    }

    // Resultエリアの縦サイズ
    final heightA = maxHeight * (15 / 100);
    // テンキーエリアの縦サイズ
    final heightB = maxHeight * (10 / 100);
    final widthB = size.width * (70 / 100);
    final heightC = maxHeight * (10 / 100);
    final widthC = size.width * (90 / 100);
    final heightD = maxHeight * (65 / 100);
    final widthD = size.width * (50 / 100);

    final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

    List<String> _items = ["A", "B", "C"];
    String _selectedItem = "A";

    // int NameSort = 0;
    // int PriceSort = 0;
    // String data ="";

    return Scaffold(
      backgroundColor: Colors.black,
      drawerEdgeDragWidth: 0, //　ボタンのみでドロワーを開ける様にする(スワイプでドロワーを開けるエリアを0にする）
      endDrawer: SizedBox(width: widthD, child: Drawer()),
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.0,
          bottom: TabBar(tabs: tabs,
            controller: _tabController,)
      ),
      body: Container(
        child: Column(
        children: <Widget>[

          //値段を表示するところ
          Container(
            decoration: BoxDecoration(color: Colors.black),
            width: size.width,
            height: heightA,
            // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Text(
              '¥ '+'$_counter',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1, fontSize: 45,fontWeight: FontWeight.bold,color: Colors.white),

            ),
          ),


          // タブ選択とソートのところ
          Container(
            decoration: BoxDecoration(color: Colors.black),
            width: widthC,
            height: heightC,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween  ,
              children: <Widget>[
                // タブ選択の詳細
                  DropdownButton<String>(
                  value: _selectedItem,
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),

                  onChanged: (String newValue) {
                    setState(() {
                      _selectedItem = newValue;
                    });
                  },
                  selectedItemBuilder: (context) {
                    return _items.map((String item) {
                      return Text(
                        item,
                        style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold,height: 1.5),
                      );
                    }).toList();
                  },
                  items: _items.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: item == _selectedItem
                            ? TextStyle(fontWeight: FontWeight.bold)
                            : TextStyle(fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                ),

                // ソートのボタン
                // ButtonTheme(
                //     minWidth: 10.0,
                //     child:RaisedButton(
                //       color: Colors.white,
                //       child: NameSort == 0? Text("data"):Text("data1"),
                //       onPressed: () {
                //         setState(() {
                //           NameSort += 1;
                //           if(NameSort % 2 == 1){
                //             data = "Name1";
                //           }else if(NameSort % 2 == 0){
                //             data = "Name2";
                //           }
                //         },
                //         );
                //       },
                //
                //     )
                // ),
                // ButtonTheme(
                //     minWidth: 10.0,
                //     child:RaisedButton(
                //         color: Colors.white,
                //       child: cmbscritta ? Text("GeoOn") : Text("GeoOFF"),
                //         onPressed: () {
                //           setState(() {
                //             pressGeoON = !pressGeoON;
                //             cmbscritta = !cmbscritta;
                //           });
                //         },
                //
                //     )
                // )

              ],
            ),
          ),

      Container(
        decoration: BoxDecoration(color: Colors.black),
        width: size.width,
        height: heightD,
          child:StreamBuilder<List<Subsuc>>(
            stream: _bloc.todoStream,
            builder: (BuildContext context, AsyncSnapshot<List<Subsuc>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {

                    Subsuc todo = snapshot.data[index];

                    return Dismissible(
                      key: Key(todo.id),
                      background: _backgroundOfDismissible(),
                      secondaryBackground: _secondaryBackgroundOfDismissible(),
                      onDismissed: (direction) {
                        _bloc.delete(todo.id);
                      },
                      child: Card(
                          child: ListTile(
                            onTap: (){
                              _moveToEditView(context, _bloc, todo);
                            },
                            title: Text("${todo.name}"),
                            subtitle: Text("${todo.amount} 円"),
                            trailing: Text("${(todo.startDate.year).toString()+"/"+(todo.startDate.month).toString()+"/"+(todo.startDate.day).toString()}"),
                            isThreeLine: true,
                          )
                      ),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
      ),


          // // 広告
          // Container(
          //   decoration: BoxDecoration(color: Colors.purple),
          //   width: size.width,
          //   height: heightC,
          // ),
          //

      ]
        ),),
      floatingActionButton:Container(
      // margin:EdgeInsets.only(bottom: 70.0),
      child:FloatingActionButton(
      onPressed:(){ _moveToCreateView(context, _bloc); },
        child: Icon(Icons.add, size: 40),
      ),
      ),
    );

  }

  _moveToEditView(BuildContext context, TodoBloc bloc, Subsuc todo) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoEditView(todoBloc: bloc, todo: todo))
  );

  _moveToCreateView(BuildContext context, TodoBloc bloc) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TodoEditView(todoBloc: bloc, todo: Subsuc.newTodo()))
  );

  _backgroundOfDismissible() => Container(
      alignment: Alignment.centerLeft,
      color: Colors.redAccent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Icon(Icons.delete, color: Colors.white),
      )
  );

  _secondaryBackgroundOfDismissible() => Container(
      alignment: Alignment.centerRight,
      color: Colors.redAccent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Icon(Icons.delete, color: Colors.white),
      )
  );
}