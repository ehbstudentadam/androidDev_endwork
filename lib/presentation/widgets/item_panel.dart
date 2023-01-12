import 'package:flutter/material.dart';
import '../../data/models/item.dart';

class ItemPanel extends StatelessWidget {
  final Item item;

  const ItemPanel({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Expanded(
        child: Container(
          color: const Color(0xECECECFF),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  item.images?.first ??
                      "https://firebasestorage.googleapis.com/v0/b/drop-a1df0.appspot.com/o/application%2FCapture.JPG?alt=media&token=c32fe297-9d4a-4ef2-9021-5330dad0a338",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Row(
                        children: [
                          Text(
                            item.price.toString(),
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          IconButton(

                              icon: const Icon(Icons.favorite),
                              onPressed: () {
                                //code to execute when this button is pressed
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
