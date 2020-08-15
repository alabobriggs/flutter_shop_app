import 'package:flutter/material.dart';
import '../providers/cart.dart' show CartProvider;
import '../providers/orders.dart';
import 'package:provider/provider.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<OrdersProvider>(
                  context,
                  listen: false,
                ).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );

                setState(() {
                  _isLoading = true;
                });

                widget.cart.clear();
              } catch (err) {
                print(err);
              }
            },
      child: Text(
        'Order now',
        style: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : TextStyle(
                color: Theme.of(context).primaryColor,
              ),
      ),
    );
  }
}
