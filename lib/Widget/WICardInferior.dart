
import 'package:flutter/material.dart';


class WICardInferior extends StatefulWidget {
  var TextNome;
  var TextButton;
  final Function()? callback;
  final IconData ?icon;

  WICardInferior({
    this.TextNome,
    this.TextButton,
    this.callback,
    this.icon

  });
  @override
  _WICardInferiorState createState() => _WICardInferiorState();

}


class _WICardInferiorState extends State<WICardInferior> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Positioned(
       left: 0.0,
       right: 0.0,
       bottom: 0.0,
       child: AnimatedSize(
         curve:Curves.bounceIn,
         duration:new Duration(milliseconds: 160),
         child: Container(
           height:150,
           decoration: BoxDecoration(
             //cor da caixa grande
             //color: Colors.white,
             // color: Colors.black87,
             color:  Color(0xCC383535),
             borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(18.0),
                 topRight: Radius.circular(18.0)),
             boxShadow: [
               BoxShadow(
                 //sombra da caixa de pesquisa
                 //color: Colors.white,
                 //color: Theme.of(context).textTheme.bodyText2.color,
                 blurRadius: 16.0,
                 spreadRadius: 0.5,
                 offset: Offset(0.7, 0.7),
               )
             ],
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
              Flexible(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     SizedBox(height: 6.0),
                         Text(
                          widget.TextNome!=null?
                           "Olá "+widget.TextNome:"",
                           overflow: TextOverflow.ellipsis,
                           maxLines: 1,
                           softWrap: false,
                           style: TextStyle(
                               fontSize: 14.0,
                               fontFamily: "Brand Bold",
                               color:Color(0xFFCECACA)
                           ),
                         ),
                     SizedBox(height: 20.0),

                     Padding(
                       padding: const EdgeInsets.symmetric(
                           horizontal: 04.0),
                       child: Container(
                         width: 300.0,
                         height: 50.0,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20),
                           gradient: LinearGradient(
                             colors: [
                               Color(0xFF933A3A),
                               Color(0xFF742828)
                             ],
                           ),
                         ),
                         child:
                         ElevatedButton.icon(
                             icon: Icon(widget.icon, color: Colors.white54,size:18.0,),
                             label:Text(widget.TextButton),
                             style: ElevatedButton.styleFrom(
                               onSurface: Colors.grey,
                               shape: const BeveledRectangleBorder
                                 (borderRadius: BorderRadius.all(Radius.circular(5))),

                               textStyle: TextStyle(
                                   color: Colors.white54,
                                   fontSize: 20,
                                   fontFamily: "Brand Bold"
                                   ,fontWeight: FontWeight.bold
                               ),
                             ),
                             onPressed:widget.callback
                         ),
                       ),
                     ),

                     //localizacoes cadastrada
                     SizedBox(height: 10.0),

                   ],
                 ),
             ),
             ],
           ),
         ),
       )
   );
  }

}