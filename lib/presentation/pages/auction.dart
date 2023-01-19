import 'package:drop_application/data/models/item.dart';
import 'package:drop_application/presentation/widgets/biding_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auction/auction_bloc.dart';
import '../../bloc/bid/bid_bloc.dart';
import '../widgets/menu_drawer.dart';
import '../widgets/user_drawer.dart';

class Auction extends StatelessWidget {
  final Item item;

  const Auction({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      endDrawer: const MenuDrawer(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuctionBloc, AuctionState>(
            listener: (context, state) {
              if (state is AuctionErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
              if (state is AuctionLoadedState) {
                context.read<BidBloc>().add(LoadAllBidsEvent(item));
              }
            },
          ),
          BlocListener<BidBloc, BidState>(
            listener: (context, state) {
              if (state is BidErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
          ),
        ],
        child: BlocBuilder<AuctionBloc, AuctionState>(
          builder: (context, state) {
            if (state is AuctionLoadingState) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AuctionLoadedState) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: false,
                    leading: IconButton(
                      onPressed: () {
                        return Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.account_circle),
                    ),
                    title: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'DROP',
                      ),
                    ),
                    actions: [
                      IconButton(
                          icon: const Icon(Icons.home),
                          onPressed: () {
                            if (GoRouter.of(context).location == '/dashboard' ||
                                GoRouter.of(context).location == '/') {
                              //do nothing
                            }
                          }),
                      IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            return Scaffold.of(context).openEndDrawer();
                          }),
                    ],
                    bottom: AppBar(
                      shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      automaticallyImplyLeading: false,
                      actions: <Widget>[Container()],
                      title: Center(
                        child: Text(item.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ),
                  // Other Sliver Widgets
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Color(0xECECECFF),
                          ),
                          //color: const Color(0xECECECFF),
                          child: ImageSlideshow(
                            width: double.infinity,
                            height: 200,
                            initialPage: 0,
                            isLoop: true,
                            indicatorColor: Colors.deepPurple,
                            indicatorBackgroundColor: Colors.grey,
                            children: imageList(item),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          state.dbUser.userName,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: BiddingPanel(
                          item: item,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                "Date created: ${item.timestamp}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Text(
                              item.description,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      )
                    ]),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

List<Widget> imageList(Item item) {
  List<Image> imageList = [];

  if (item.images?.first == "") {
    imageList.add(Image.network(
        'https://firebasestorage.googleapis.com/v0/b/drop-a1df0.appspot.com/o/application%2Fno_image_in_database.png?alt=media&token=8f78766d-c27d-4a08-8707-44828f0791f9'));
    return imageList;
  }

  item.images?.forEach((element) {
    imageList.add(Image.network(element));
  });

  return imageList;
}
