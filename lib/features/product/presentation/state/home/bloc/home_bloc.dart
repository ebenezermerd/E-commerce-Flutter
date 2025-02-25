import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop/features/product/domain/entities/product.dart';
import 'package:shop/features/product/domain/repositories/product_repository.dart';
import 'package:shop/features/product/domain/usecases/get_filtered_products.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository repository;
  final GetFilteredProducts getFilteredProducts;

  HomeBloc({
    required this.repository,
    required this.getFilteredProducts,
  }) : super(HomeInitial()) {
    on<LoadProductsByFilter>(_onHomeEvent);
  }

  Future<void> _onHomeEvent(HomeEvent event, Emitter<HomeState> emit) async  {
    if (event is LoadProductsByFilter) {
      emit(HomeLoading());
      final result = await getFilteredProducts(null);
      result.fold(
        (failure) => emit(HomeError(failure.toString())),
        (products) => emit(HomeLoaded(products)),
      );
    }
  }
}
