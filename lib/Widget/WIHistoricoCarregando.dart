import 'package:flutter/material.dart';

class WIHistoricoCarregando extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {
    return Card(
      color:  Color(0xFF4B4545),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            ListTile( title:
            Text("Carregando..",
            style:TextStyle(
                color: Colors.white70
            ),
            ),
                subtitle: Text("Carregando..",
                  style:TextStyle(
                      color: Colors.white70
                  ),
                ),

                leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,),
                trailing: Icon(Icons.watch_later_outlined,
                color: Colors.white70,
                )
            ),
             ],
        ),
      ),
    );
  }
}
