import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' as orderProvider;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: FutureBuilder(
            future: Provider.of<orderProvider.OrdersProvider>(
              context,
              listen: false,
            ).fetchAndSetOrders(),
            builder: (ctx, dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (dataSnapShot.error != null) {
                return Center(
                  child: Text('Mighty Error Occured'),
                );
              }
              return Consumer<orderProvider.OrdersProvider>(
                builder: (ctx, ordersData, child) {
                  return ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (_, idx) => OrderItem(
                      ordersData.orders[idx],
                    ),
                  );
                },
              );
            }));
  }
}
