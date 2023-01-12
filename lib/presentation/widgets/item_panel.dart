import 'package:flutter/material.dart';
import '../../data/models/item.dart';

class ItemPanel extends StatelessWidget {
  final Item item;

  const ItemPanel({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Color(0xECECECFF),
        ),
        //color: const Color(0xECECECFF),
        child: Row(
          children: [
            SizedBox(
                width: 100,
                height: 100,
                child: Builder(
                  builder: (BuildContext context) {
                    if (item.images?.first == "") {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                        child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/drop-a1df0.appspot.com/o/application%2Fno_image_in_database.png?alt=media&token=8f78766d-c27d-4a08-8707-44828f0791f9",
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                        child: Image.network(
                          item.images?.first ??
                              "https://firebasestorage.googleapis.com/v0/b/drop-a1df0.appspot.com/o/application%2Fno_image_in_database.png?alt=media&token=8f78766d-c27d-4a08-8707-44828f0791f9",
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.price.toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              icon: const Icon(Icons.favorite),
                              onPressed: () {
                                //code to execute when this button is pressed
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
