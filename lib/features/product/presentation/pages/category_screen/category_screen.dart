import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/features/product/presentation/state/product/bloc/product_bloc.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';

import '../../../../../../constants.dart';
import '../../../../../screens/search/views/components/search_form.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});
  // final String category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // pinned: true,
        // floating: true,
        // snap: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        title: SvgPicture.asset(
          "assets/logo/Shoplon.svg",
          colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color!, BlendMode.srcIn),
          height: 20,
          width: 100,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, notificationsScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Stores.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductError) {
            return const Center(child: Text("Error"));
          }
          if (state is ProductLoaded) {
           
           return CustomScrollView(
            slivers: [
              // While loading use 👇
              //  BookMarksSlelton(),

              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ProductCard(
                        image: state.products[index].coverUrl,
                        brandName: state.products[index].name,
                        title: state.products[index].subDescription,
                        price: state.products[index].price,
                        priceAfetDiscount:
                            state.products[index].priceSale,
                        dicountpercent:
                            10,
                        press: () {
                          // Navigator.pushNamed(
                          //     context, productDetailsScreenRoute);
                          Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: {
                            'isProductAvailable': true,
                            'productId': state.products[index].id,
                          },
                          
                        );
                        },
                      );
                    },
                    childCount: state.products.length,
                  ),
                ),
              ),
            ],
          );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
