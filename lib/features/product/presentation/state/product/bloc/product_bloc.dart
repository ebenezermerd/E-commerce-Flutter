import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/fetch_all_products.dart';
import '../../../../domain/usecases/fetch_product_detail.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../domain/entities/product.dart';
import '../../../../data/datasources/product_remote_data_source.dart';
import '../../../../domain/repositories/product_repository.dart';
import '../../../../domain/usecases/get_products_by_category.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  final GetProductsByCategory getProductsByCategory;

  ProductBloc({
    required this.repository,
    required this.getProductsByCategory,
  }) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());

      final result = await repository.getProducts();
      print("result");
      print(result);

      result.fold(
        (failure) => emit(ProductError(message: 'Failed to load products')),
        (products) {
          final hotDeals = products
              .where((p) =>
                  p.totalRatings >= 4 ||
                  p.totalSold > 1 ||
                  (p.priceSale ?? 0) > 0)
              .toList();

          final countdownProducts = products
              .where((p) =>
                  (p.priceSale ?? 0) > 0 &&
                  p.saleLabel.enabled &&
                  p.quantity > 0)
              .take(2)
              .toList();

          final specialOffer = products
              .where((p) =>
                  (p.priceSale ?? 0) > 0 &&
                  p.saleLabel.enabled &&
                  p.quantity > 0)
              .reduce((a, b) => ((b.price - (b.priceSale ?? 0)) >
                      (a.price - (a.priceSale ?? 0)))
                  ? b
                  : a);
          print("products");
          for (var product in products) {
            print(product);
          }
          emit(ProductLoaded(
            products: products,
            hotDeals: hotDeals,
            countdownProducts: countdownProducts,
            specialOffer: specialOffer,
          ));
        },
      );
    });

    on<LoadProductsByCategory>((event, emit) async {
      emit(ProductLoading());

      final result = await getProductsByCategory(event.category);
      // print("result");
      // print(result);

      result.fold(
        (failure) => emit(ProductError(message: 'Failed to load products')),
        (products) => emit(ProductLoaded(products: products)),
      );
    });
    on<LoadProductById>(_loadProductById);
    
  }

  void _loadProductById(
      LoadProductById event, Emitter<ProductState> emit) async {
    emit(ProductDetailsLoading());
    final result = await repository.getProductById(event.productId);

    result.fold(
      (failure) => emit(ProductDetailsError(message: 'Failed to load product')),
      (product) => emit(ProductDetailsLoaded(product: product)),
    );
  }
}
