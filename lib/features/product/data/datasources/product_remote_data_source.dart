import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProductRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/products/list'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        // print('Response body: ${response.body}');
        final decodedResponse = json.decode(response.body);
        // print("decodedResponse");
        // print({decodedResponse});


        // Handle both cases: direct array or nested in products field
        List<dynamic> productsJson;
        if (decodedResponse is Map<String, dynamic>) {
          productsJson = decodedResponse['products'] as List<dynamic>;
          // print("productsJson");
          // print(productsJson);
        } else if (decodedResponse is List) {
          // print("decodedResponse is List");
          // print(decodedResponse);
          productsJson = decodedResponse;
          // print("productsJson");
          // print(productsJson);
        } else {
          // print(productsJson);
          throw ServerException('Invalid response format');
        }

        return productsJson.map((json) {
          try {
            return ProductModel.fromJson(json);
          } catch (e) {
            // print('Error parsing product: $e');
            // print('Product JSON: $json');
            rethrow;
          }
        }).toList();
      } else {
        throw ServerException('Failed to load products');
      }
    } catch (e) {
      // print('Error fetching products: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      // final response = await client.get(
      //   Uri.parse('$baseUrl/api/products/details'),
      //   headers: {
      //     'Accept': 'application/json',
      //     'Content-Type': 'application/json'
      //   },
      //   body: json.encode({'productId': productId}),
      // );
      final uri = Uri.parse('https://api.korecha.com.et/api/products/details');
      final request = http.Request('GET', uri)
        ..headers.addAll({
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        })
        ..body = json.encode({'productId': productId});

      final response = await client.send(request);
      final responseBody = await response.stream.bytesToString();

      print("response");
      print(responseBody);
      print(response.statusCode);

      if (response.statusCode == 201) {
        final decodedResponse = json.decode(responseBody);
        final product = decodedResponse['product'];
        // final productJson = json.decode(product);
        print("product");
        print(product);
        return ProductModel.fromJson(product);
      } else {
        throw ServerException('Failed to load product');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
