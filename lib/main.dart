import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shipometer/month_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _controller;
  int currentPage = 0;
  Stream<QuerySnapshot> _query;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
    _query = Firestore.instance.collection("expenses").where("month", isEqualTo: currentPage +1).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAction(FontAwesomeIcons.history),
            _bottomAction(FontAwesomeIcons.chartPie),
            SizedBox(width: 48.0,),
            _bottomAction(FontAwesomeIcons.wallet),
            _bottomAction(Icons.settings),
          ],
        ),
      ),
      body: _createBody(),
    );
  }

  Widget _bottomAction(IconData icon){
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: (){},
    );
  }

  Widget _createBody() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _createSelector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data){
              if(data.hasData){
                return MonthWidget(documents: data.data.documents);
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              
            },
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position){
    var _alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4)
    );
    if(position == currentPage){
      _alignment = Alignment.center;
    }
    else if(position > currentPage){
      _alignment = Alignment.centerRight;
    }
    else{
      _alignment = Alignment.centerLeft;
    }
    return Align(
      alignment: _alignment,
      child: Text(name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _createSelector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        controller: _controller,
        onPageChanged: (newPage){
          setState(() {
            currentPage = newPage;
            _query = Firestore.instance.collection("expenses").where("month", isEqualTo: currentPage +1).snapshots();
          });
        },
        children: <Widget>[
          _pageItem("Enero", 0),
          _pageItem("Febrero", 1),
          _pageItem("Marzo", 2),
          _pageItem("Abril", 3),
          _pageItem("Mayo", 4),
          _pageItem("Junio", 5),
          _pageItem("Julio", 6),
          _pageItem("Agosto", 7),
          _pageItem("Septiembre", 8),
          _pageItem("Octubre", 9),
          _pageItem("Noviembre", 10),
          _pageItem("Diciembre", 11),
        ],
      ),
    );
  }

  

  

}