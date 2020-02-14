import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsBoxFavourit extends StatefulWidget {
  final int _num;
  final bool _like;

  NewsBoxFavourit(this._num, this._like);

  @override
  createState() => new NewsBoxFavouritState(_num, _like);
}

class NewsBoxFavouritState extends State<NewsBoxFavourit> {
  int num;
  bool like;

  NewsBoxFavouritState(this.num, this.like);

  void pressButton() {
    setState(() {
      like = !like;

      if(like) num++;
      else num--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      new Text('В избранном$num', textAlign: TextAlign.center),
      new IconButton(
        icon: new Icon(like ? Icons.star : Icons.star_border, size: 30.0, color: Colors.blue[500]),
    onPressed: pressButton
    )
    ]);
  }
}

class NewsBox extends StatelessWidget {
  final String _title;
  final String _text;
  String _imageurl;
  int _num;
  bool _like;

  NewsBox(this._title, this._text, {String imageurl, int num = 0, bool like = false}) {
    _imageurl = imageurl;
    _num = num;
    _like = like;
  }

  @override
  Widget build(BuildContext context) {
    if (_imageurl != null && _imageurl != '') return new Container(
        color: Colors.black12,
        height: 100.0,
        child: new Row(children: [
          new Image.network(_imageurl, width: 100.0, height: 100.0, fit: BoxFit.cover,),
          new Expanded(child: new Container(padding: new EdgeInsets.all(5.0), child: new Column(children: [
            new Text(_title,  style: new TextStyle(fontSize: 20.0), overflow: TextOverflow.ellipsis),
            new Expanded(child:new Text(_text, softWrap: true, textAlign: TextAlign.justify,))
          ]
          ))
          ), new NewsBoxFavourit(_num, _like)
        ])
    );

    return new Container(
        color: Colors.black12,
        height: 100.0,
        child: new Row(children: [
          new Expanded(child: new Container(padding: new EdgeInsets.all(5.0), child: new Column(children: [
            new Text(_title, style: new TextStyle(fontSize: 20.0), overflow: TextOverflow.ellipsis),
            new Expanded(child:new Text(_text, softWrap: true, textAlign: TextAlign.justify,))
          ]
          ))
          ),  new NewsBoxFavourit(_num, _like)
        ])
    );
  }
}

class MyBody extends StatefulWidget {

  @override
  createState() => new MyBodyState();
}

class MyBodyState extends State<MyBody> {

  List<String> _array = [];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(itemBuilder: (context, i){
      print('num $i : нечетное = ${i.isOdd}');

      if(i.isOdd) return new Divider();

      final int index = i ~/ 2;

      print('index $index');
      print('length ${_array.length}');
      
      if(index >= _array.length) _array.addAll(['$index', '${index + 1}', '${index + 2}']);
      return new ListTile(title: new Text(_array[index]));
    });
  }
}

class MyForm extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _formKey = GlobalKey<FormState>();
  GenderList _gender;
  bool _agreement = false;

  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(10.0), child: new Form(key: _formKey,
        child: new Column(children: <Widget>[
          new Text('Имя пользователя:', style: TextStyle(fontSize: 20.0),),
          new TextFormField(validator: (value){
            if (value.isEmpty) return 'Пожалуйста введите свое имя';
          }),

          new SizedBox(height: 20.0),

          new Text('Контактный E-mail:', style: TextStyle(fontSize: 20.0),),
          new TextFormField(validator: (value){
            if (value.isEmpty) return 'Пожалуйста введите свой Email';

            String p = "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
            RegExp regExp = new RegExp(p);

            if (regExp.hasMatch(value)) return null;

            return 'Это не E-mail';
          }),
          
          new SizedBox(height: 20.0),

          new Text('Ваш пол: ', style: TextStyle(fontSize: 20.0)),

          new RadioListTile(
            title: const Text('Мужской'),
            value: GenderList.male,
            groupValue: _gender,
            onChanged: (GenderList value) {setState(() { _gender = value;});},
          ),

          new RadioListTile(
            title: const Text('Женский'),
            value: GenderList.female,
            groupValue: _gender,
            onChanged: (GenderList value) {setState(() { _gender = value;});},
          ),

          new SizedBox(height: 20.0),
          
          new CheckboxListTile(value: _agreement, 
              title: new Text('Я ознакомлен'+(_gender==null?'(а)':_gender==GenderList.male?'':'а')+' с '
                  'документом "Согласие на обработку персональных данных" и даю согласие на обработку '
                  'моих персональных данных в соответствии с требованиями "Федерального закона '
                  'О персональных данных № 152-ФЗ".'),
              onChanged: (bool value) => setState(() => _agreement = value)),
          
          new RaisedButton(onPressed: () {
            if(_formKey.currentState.validate()) {
              Color color = Colors.red;
              String text;

              if (_gender == null)
                text = 'Выберите свой пол';
              else if (_agreement == false)
                text = 'Необходимо принять условия соглашения';
              else {
                text = 'Форма успешно заполнена';
                color = Colors.green;
              }

              Scaffold.of(context).showSnackBar(SnackBar(content: Text(text),
                  backgroundColor: color));
            }
          }, child: Text('проверить'), color: Colors.blue, textColor: Colors.white)
          
        ])));
  }
}

enum GenderList {male, female}

class MainScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('main screen')),
      body: Center(child: Column(children: <Widget>[
        RaisedButton(onPressed: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen()));
          Navigator.pushNamed(context, '/second');
        }, child: Text('Открыть второе окно')),
        RaisedButton(onPressed: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => SecondScreen()));
          Navigator.pushNamed(context, '/second/123');
        }, child: Text('Открыть второе окно 123')),
        RaisedButton(onPressed: () async {
          bool value = await Navigator.push(context, PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _,__) => MyPopUp(),
            transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
              return FadeTransition(
                opacity: animation,
                  child: ScaleTransition(scale: animation, child: child)
              );
            }
          ));

          if (value) _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Больше'), backgroundColor: Colors.green,));// TRUE
          else _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Меньше'), backgroundColor: Colors.red,));// FALSE

        }, child: Text('open dialog'))
      ]))
    );
  }
}

class MyPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text("text"),
      actions: <Widget>[
        FlatButton(
          onPressed: () { Navigator.pop(context, true);},
          child: Text('1')
        ),
        FlatButton(
          onPressed: () { Navigator.pop(context, false);},
          child: Text('2')
        )
      ]
    );
  }
}

class SecondScreen extends StatelessWidget {
  String _id;
  SecondScreen({String id}):_id = id;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('second screen $_id')),
      body: Center(child: RaisedButton(onPressed: () {
        Navigator.pop(context);
      }, child: Text('Back')))
    );
  }
}

class SandClass {
  int _sand = 0;

  Future tick() async {
    _sand = 100;
    print("start:tick");
    while(_sand > 0) {
      print('tick: $_sand');
      _sand--;
      await new Future.delayed(const Duration(milliseconds: 100));
    }
    print('end:tick');
  }

  time() {
    return _sand;
  }
}

class MyAppState extends State {
  SandClass clock = SandClass();

  _reDrawWidget() async {
    if (clock.time() == 0) return;
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      print('reDrawWidget()');
    });
  }

  @override
  void initState() {
    clock.tick();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _reDrawWidget();

    print('clock.tick: ${clock.time()}');

    return Center(child: Text('time is: ${clock.time()}'));
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}



void main() =>  runApp(

  new MaterialApp(
    home: Scaffold(body: MyApp())
  )

//  new MaterialApp(
//    routes: {
//      '/':(BuildContext context) => MainScreen(),
//      '/second':(BuildContext context) => SecondScreen()
//    },
//
//      onGenerateRoute: (routeSettings){
//        var path = routeSettings.name.split('/');
//
//        if (path[1] == "second") {
//          return new MaterialPageRoute(
//            builder: (context) => new SecondScreen(id:path[2]),
//            settings: routeSettings,
//          );
//        }
//      }
//    //home: MainScreen()
//  )

//  new MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: new Scaffold(
//        appBar: new AppBar(title: new Text("форма ввода")),
//        body: new MyForm()
//      )
//  )

//  new MaterialApp(
//    debugShowCheckedModeBanner: false,
//    home: new Scaffold(body: new Center(child: new MyBody()))
//  )



//  new MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: new Scaffold(
//        body: new MyWidget(),
//      )
//  )


//  new MaterialApp(
//      debugShowCheckedModeBanner: false,
//          home: new Scaffold(
//            body: new ListView(children: <Widget>[
//              new Text('0000'),
//              new Divider(),
//              new Text('0001'),
//              new Divider(),
//              new Text('0002')
//            ])
//          )
//  )


//    new MaterialApp(
////        debugShowCheckedModeBanner: false,
////        home: new Scaffold(
////            appBar: new AppBar(),
////            body: new NewsBox('Новый урок по Flutter', '''В новом уроке рассказывается, в каких случаях применять класс StatelessWidget и StatefulWidget. Приведены примеры их использования.''',
////                imageurl: 'https://flutter.su/favicon.png', num: 10)
////        )
////    )
);

class MyWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        children: [
          new Text('Hello World!'),
          new FlatButton(onPressed: () async {
            const url = 'https://flutter.su';
            if(await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }, child: Text('open url'), color: Colors.green,textColor: Colors.white,
        )],
      )
    );
  }
}
