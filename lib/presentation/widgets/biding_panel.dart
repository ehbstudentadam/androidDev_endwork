import 'package:drop_application/bloc/bid/bid_bloc.dart';
import 'package:drop_application/data/models/bid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/item.dart';

class BiddingPanel extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _bidController = TextEditingController();

  final Item item;

  BiddingPanel({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BidBloc, BidState>(
      listener: (context, state) {
        if (state is BidErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      buildWhen: (previous, current) =>
          current is BidsLoadedState && previous != current,
      builder: (context, state) {
        if (state is BidsLoadingState) {
          context.read<BidBloc>().add(LoadAllBidsEvent(item));
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is BidsLoadedState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<List<Bid>>(
              stream: state.bids,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  throw snapshot.error!;
                }
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.price.toString(),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 100,
                              height: 60,
                              child: TextFormField(
                                style: Theme.of(context).textTheme.headline5,
                                controller: _bidController,
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
                            TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<BidBloc>().add(CreateBidEvent(
                                      item, double.parse(_bidController.text)));
                                }
                              },
                              child: Text(
                                'PLACE BID',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return BidRow(bid: snapshot.data![index]);
                          },
                          itemCount: snapshot.data?.length,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}

class BidRow extends StatelessWidget {
  final Bid bid;

  const BidRow({Key? key, required this.bid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          bid.userName,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          bid.price.toString(),
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }
}
