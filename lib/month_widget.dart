import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'graph_widget.dart';

class MonthWidget extends StatefulWidget {

  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String,double> categories;

  MonthWidget({Key key,this.documents}): 
  total = documents.map( (doc) => doc.data["value"] ).fold(0.0, (a,b) => a + b ),
  perDay = List.generate(30, (int index){
    return documents.where((doc) => doc.data["day"] == (index+1)).map((doc) => doc.data["value"]).fold(0.0, (a,b)=> a+b);
  }),
  categories = documents.fold( {}, (Map<String,double> map, document ){
    print(map);
    print(document.data);

    if( !map.containsKey(document.data["category"])){
      map[document.data["category"]] = 0.0;
    }
    map[document.data["category"]] += document.data["value"];
    return map;
  }),
  super(key:key);
  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          _createExpenses(),
          _createGraph(),
          Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 24.0,
          ),
          _createList(),
        ],
      ),
    );
  }

  Widget _createExpenses() {
    return Column(
      children: <Widget>[
        Text(
          "\$${widget.total.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        Text(
          "Total expenses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueGrey
          ),
        )
      ],
    );
  }

  Widget _createGraph() {
    return Container(
      height: 250.0,
      child: GraphWidget(data: widget.perDay,)
    );
  }

  Widget _createList() {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index){
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];
          return _createItem(FontAwesomeIcons.shoppingCart, key, 100* data~/widget.total, data);
        },
        separatorBuilder: (BuildContext context, int index){ 
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 8.0,
          );
        },
        itemCount: widget.categories.keys.length,
      ),
    );
  }

  Widget _createItem(IconData icon, String name, int percent, double value){
    return ListTile(
      leading: Icon(icon, size: 32.0,),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blueGrey,
        ),
      ),
      subtitle: Text("$percent% of expenses"),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "\$$value",
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
              fontSize: 16.0
            ),
          ),
        ),
      ),
    );
  }
}