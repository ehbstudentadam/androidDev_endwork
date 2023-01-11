import 'package:flutter/material.dart';
import '../../data/models/item.dart';

class ItemPanel extends StatelessWidget {
  final Item item;

  const ItemPanel({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 75,
          height: 75,
          child: Image.network(
            item.images?.first ?? "https://firebasestorage.googleapis.com/v0/b/drop-a1df0.appspot.com/o/test%2FCapture.JPG?alt=media&token=3e984df1-76ee-41f2-8dea-f57b2db461e2",
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            Text(item.title),
            Row(
              children: [
                Text(item.price.toString()),
                IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      //code to execute when this button is pressed
                    }),
              ],
            )
          ],
        )
      ],
    );
  }
}
