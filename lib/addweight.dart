import 'package:flutter/material.dart';
import 'main.dart';

class AddWeight extends StatefulWidget {

  const AddWeight({Key? key, required this.containerLists,required this.whichMove}) : super(key: key);
  final List<GestureDetector> containerLists;
  final String whichMove;

  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {

  String weight = '';
  String set = '';
  String rep = '';
  String thisMove = "";
  List<GestureDetector> realContainerLists = [];
  List<Map<String,String>> moves = [];
  List<Moves> movesLists = [];
  int i = 0;

  @override
  void initState() {
    realContainerLists = widget.containerLists;
    thisMove = widget.whichMove;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF06283D),
        body: Column(
          children: [
            Container(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('FITSHARE',style: TextStyle(fontFamily: 'Mrs. Monster',fontSize: 40,color: Colors.white),
                ),
              ],
            ),
            Container(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(thisMove,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),
                ),
              ],
            ),
            Container(height: 30),
            Row(
              children: [
                Container(width: 25,),
                Text('Weight',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Colors.white),),
                Container(width: 113,),
                Text('Set',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Colors.white),),
                Container(width: 70,),
                Text('Rep',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Colors.white),),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 13,top: 10),
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Center(
                    child: TextField(
                      onChanged: (text) {
                        weight = text;
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: InputBorder.none

                      ),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(width:50,),
                Container(
                  margin: EdgeInsets.only(left: 13,top: 10),
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Center(
                    child: TextField(
                      onChanged: (text) {
                        set = text;
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: InputBorder.none

                      ),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 13,top: 10),
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Center(
                    child: TextField(
                      onChanged: (text) {
                        rep = text;
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: InputBorder.none

                      ),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Moves>>(
                  future: DatabaseHelper.instance.getMoves(thisMove),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Moves>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text('Loading...'));
                    }
                    return ListView(
                      children: snapshot.data!.map((moves) {
                        return GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                              width: 165,
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Center(
                                child: Text(
                                  'Weight: ${moves.weight}Kg  Sets:${moves.seta} Rep:${moves.rep}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            onLongPress: () {
                              showDialog(context: this.context, builder: (ctx) => AlertDialog(
                                title: Text("Do you want to delete it?"),
                                actions: [
                                  TextButton(onPressed: (){
                                    setState(() {
                                      DatabaseHelper.instance.removeFromWeights(moves.weight,moves.seta,moves.rep);
                                    });
                                    Navigator.of(ctx).pop();
                                  }, child: Text('yes')),
                                  TextButton(onPressed: () {
                                    Navigator.of(ctx).pop();
                                  }, child: Text('no')),
                                ],
                              ));
                            }
                        );
                      }).toList(),
                    );
                  }),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 40,left: 10),
                  child: GestureDetector(child: Image.asset('images/addbutton.png'),onTap: () {
                    if(weight != '' && set != '' && rep != '') {
                      setState(() {
                        DatabaseHelper.instance.add(
                            Moves(moveName: thisMove, weight: weight, seta: set, rep: rep)
                        );
                      });
                    }else {
                      showDialog(context: this.context, builder: (ctx) => AlertDialog(
                        title: Text("You have to fill in all the blanks."),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(ctx).pop();
                          }, child: Text('Ok')),
                        ],
                      ));
                    }
                  },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 40,left: 20),
                  child: GestureDetector(child: Image.asset('images/savebutton.png'),onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
