import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

abstract class EarningModel extends StatelessWidget {
  late Size size;

  var initial_date = DateTime.now();
  var end_date = DateTime.now();

  late BuildContext context;

  DateFormat format = DateFormat("dd/MM");

  var filterNames = ["Hoje", "Ontem", "Semana", "Mês", "Customizado"];

  void selectFilter() async {
    var orderController = Provider.of<OrderController>(context, listen: false);
    var selectedFilter = orderController.selectedFilter;
    var result = await showDialog(
        context: context,
        builder: (c) {
          return StatefulBuilder(builder: (c, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Hoje"),
                    onTap: () {
                      orderController.selectedFilter = 0;
                      setState(() {});
                    },
                    selected: orderController.selectedFilter == 0,
                  ),
                  ListTile(
                    title: Text(
                      "Ontem",
                    ),
                    onTap: () {
                      orderController.selectedFilter = 1;
                      setState(() {});
                    },
                    selected: orderController.selectedFilter == 1,
                  ),
                  ListTile(
                    title: Text("Semana"),
                    selected: orderController.selectedFilter == 2,
                    subtitle: Text("esta semana até agora"),
                    onTap: () {
                      orderController.selectedFilter = 2;
                      setState(() {});
                    },
                  ),
                  ListTile(
                    title: Text("Mês"),
                    selected: orderController.selectedFilter == 3,
                    subtitle: Text("este mês até agora"),
                    onTap: () {
                      orderController.selectedFilter = 3;
                      setState(() {});
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        child: TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop(false);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.calendar_today_rounded),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Calendário")
                              ],
                            )),
                      ),
                      Container(
                        height: 40,
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(c).pop(true);
                            },
                            child: Text("OK")),
                      )
                    ],
                  )
                ],
              ),
            );
          });
        });
    if (result != null) {
      if (result)
        orderController.filter();
      else {
        selectPeriodCalendar();
      }
    }
  }

  void selectPeriodCalendar() async {
    var orderController = Provider.of<OrderController>(context, listen: false);

    await showDialog(
        context: context,
        builder: (c) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(16),
              height: size.height * 0.6,
              width: size.width * 0.9,
              child: SfDateRangePicker(
                initialDisplayDate: DateTime.now(),
                selectionMode: DateRangePickerSelectionMode.range,
                cancelText: "CANCELAR",
                showActionButtons: true,
                onCancel: () {
                  orderController.selectedFilter = 0;
                },
                onSubmit: (value) {
                  if (value is PickerDateRange) {
                    orderController.selectedFilter = 4;
                    var range = value as PickerDateRange;
                    orderController.initialDate = value.startDate!;
                    orderController.endDate = value.endDate!;
                  } else {
                    orderController.selectedFilter = 0;
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        });
    orderController.filter();
  }
}
