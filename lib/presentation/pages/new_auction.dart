import 'package:drop_application/bloc/auction/auction_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/menu_drawer.dart';
import '../widgets/user_drawer.dart';

FilePickerResult? filePickerResults;

class NewAuction extends StatelessWidget {

  final List<PlatformFile> filePickerResults = [];

  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();

  NewAuction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const UserDrawer(),
      endDrawer: const MenuDrawer(),
      body: BlocConsumer<AuctionBloc, AuctionState>(
        listener: (context, state) {
          if (state is AuctionErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is PostNewAuctionLoadedState){
            GoRouter.of(context).go('/');
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Auction created!")));
          }
        },
        builder: (context, state) {
          if (state is NewAuctionLoadingState) {
            context.read<AuctionBloc>().add(NewAuctionEvent());
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is NewAuctionLoadedState) {
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
                          } else {
                            GoRouter.of(context).go('/');
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
                    title: const Center(
                      child: Text("New auction",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
                // Other Sliver Widgets
                SliverList(
                  delegate: SliverChildListDelegate([
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 32, bottom: 16),
                            child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      side: const BorderSide(
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                ),
                                label: const Text(
                                  'Upload images',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                onPressed: () async {
                                  final results =
                                      await FilePicker.platform.pickFiles(
                                    allowMultiple: true,
                                    type: FileType.image,
                                  );

                                  if (results != null) {
                                    for (var element in results.files) {
                                      filePickerResults.add(element);
                                    }
                                  }

                                  if (results == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('No files selected'),
                                    ));
                                    return;
                                  }
                                  if (results.paths.length > 5) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Maximum 5 files allowed'),
                                    ));
                                    return;
                                  }
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    "Auction title:",
                                    style:
                                        Theme.of(context).textTheme.headline4,

                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.top,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                    controller: _titleController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null && value.length > 20 && value.length < 3
                                          ? "Title between 3 ~ 20 characters"
                                          : null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    "Price:",
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: TextFormField(
                                    textAlignVertical: TextAlignVertical.top,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                    controller: _priceController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null && value.length > 10
                                          ? "Number to big"
                                          : null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    "Description:",
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    maxLines: 8,
                                    textAlignVertical: TextAlignVertical.top,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                    controller: _descriptionController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null && value.length > 180
                                          ? "Description to big"
                                          : null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              side: const BorderSide(
                                                  color: Colors.deepPurple),
                                            ),
                                          ),
                                        ),
                                        label: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        onPressed: () async {
                                          //todo
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(
                                          Icons.post_add,
                                          color: Colors.white,
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              side: const BorderSide(
                                                  color: Colors.deepPurple),
                                            ),
                                          ),
                                        ),
                                        label: const Text(
                                          'Post',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        onPressed: () {
                                          if (filePickerResults.isNotEmpty) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<AuctionBloc>().add(
                                                  PostNewAuctionEvent(
                                                      _titleController.text,
                                                      double.parse(
                                                          _priceController
                                                              .text),
                                                      _descriptionController
                                                          .text,
                                                      filePickerResults));
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "At least one image must be selected!")));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                )
              ],
            );
          }
          if (state is PostNewAuctionLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }


}
