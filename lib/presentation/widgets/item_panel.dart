import 'package:cool_alert/cool_alert.dart';
import 'package:drop_application/bloc/auction/auction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/item/item_bloc.dart';
import '../../data/models/item.dart';

class ItemPanel extends StatelessWidget {
  final Item item;

  const ItemPanel({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          context.read<AuctionBloc>().add(LoadAuctionEvent(item));
          if (GoRouter.of(context).location == '/dashboard' ||
              GoRouter.of(context).location == '/') {
            GoRouter.of(context).push('/auction', extra: item);
          } else {
            GoRouter.of(context).pushReplacement('/auction', extra: item);
          }
        },
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
                ),
              ),
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
                          Builder(
                            builder: (context) {
                              if (item.isMyItem == true) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0)),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 1,
                                          child: Icon(Icons.delete),
                                        ),
                                        DropdownMenuItem(
                                          value: 2,
                                          child: Icon(Icons.edit),
                                        )
                                      ],
                                      icon: const Icon(Icons.settings),
                                      onChanged: (value) {
                                        if (value == 1) {
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            text:
                                                "Are you sure you want to delete ${item.title}?",
                                            confirmBtnText: "Delete",
                                            cancelBtnText: "Cancel",
                                            onConfirmBtnTap: () {
                                              context
                                                  .read<ItemBloc>()
                                                  .add(DeleteItemEvent(item));
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }
                                        if (value == 2) {
                                          //todo
                                        }
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    color: (item.isMyFavourite)
                                        ? const Color(0xff6c0097)
                                        : const Color(0xffffffff),
                                    icon: const Icon(Icons.favorite),
                                    onPressed: () {
                                      if (item.isMyFavourite) {
                                        context.read<ItemBloc>().add(
                                            RemoveAsFavouriteEvent(
                                                item.itemID));
                                      } else {
                                        context.read<ItemBloc>().add(
                                            AddAsFavouriteEvent(item.itemID));
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          )
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
