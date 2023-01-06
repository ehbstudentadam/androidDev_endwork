import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bid_event.dart';
part 'bid_state.dart';

class BidBloc extends Bloc<BidEvent, BidState> {
  BidBloc() : super(BidInitial()) {
    on<BidEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
