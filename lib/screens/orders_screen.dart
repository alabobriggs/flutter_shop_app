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
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<orderProvider.OrdersProvider>(context, listen: false)
          .fetchAndSetOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<orderProvider.OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (_, idx) => OrderItem(
          ordersData.orders[idx],
        ),
      ),
    );
  }
}
