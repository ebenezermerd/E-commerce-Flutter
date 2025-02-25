part of 'product_bloc.dart';

abstract class AuthEvent {}

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class FilterProductsByCategory extends ProductEvent {
  final String category;
  FilterProductsByCategory(this.category);
}

class LoadProductsByCategory extends ProductEvent {
  final ProductCategory category;
  LoadProductsByCategory(this.category);
}

class LoadProductById extends ProductEvent {
  final String productId;
  LoadProductById(this.productId);
}
