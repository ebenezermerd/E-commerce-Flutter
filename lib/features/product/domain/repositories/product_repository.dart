import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../../../../core/error/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String productId);
}

