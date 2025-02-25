import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/buy_full_ui_kit.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/components/review_card.dart';
import 'package:shop/components/skleton/product/products_skelton.dart';
import 'package:shop/constants.dart';
import 'package:shop/core/injection/injection_container.dart';
import 'package:shop/features/product/domain/usecases/get_filtered_products.dart';
import 'package:shop/features/product/domain/usecases/get_products_by_category.dart';
import 'package:shop/features/product/presentation/state/details/bloc/details_bloc.dart';
import 'package:shop/features/product/presentation/state/home/bloc/home_bloc.dart';
import 'package:shop/features/product/presentation/widgets/details/product_buy_now_screen.dart';
import 'package:shop/screens/product/views/components/notify_me_card.dart';
import 'package:shop/screens/product/views/components/product_images.dart';
import 'package:shop/screens/product/views/components/product_info.dart';
import 'package:shop/screens/product/views/components/product_list_tile.dart';
import 'package:shop/screens/product/views/product_returns_screen.dart';

import 'package:shop/route/screen_export.dart';

Map<String, ProductCategory> categoryMap = {
  "All Categories": ProductCategory.featured,
  // "Kids": ProductFilter.kids,
  "Shirts": ProductCategory.shirts,
  "T-shirts": ProductCategory.tShirts,
  "Jeans": ProductCategory.jeans,
  "Leather": ProductCategory.leather,
  "Accessories": ProductCategory.accessories,
  "Shoes": ProductCategory.shoes,
  "Backpacks and bags": ProductCategory.backpacksAndBags,
  "Bracelets": ProductCategory.bracelets,
  "Face masks": ProductCategory.faceMasks,
  "Suits": ProductCategory.suits,
  "Blazers": ProductCategory.blazers,
  "Trousers": ProductCategory.trousers,
  "Waistcoats": ProductCategory.waistcoats,
  "Apparel": ProductCategory.apparel,
};

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen(
      {super.key, this.isProductAvailable = true, required this.productId});

  final bool isProductAvailable;
  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<DetailsBloc>()
        .add(LoadProductDetails(productId: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        if (state is DetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DetailsError) {
          return Center(child: Text(state.message));
        }
        if (state is DetailsLoaded) {
          return Scaffold(
            bottomNavigationBar: widget.isProductAvailable
                ? CartButton(
                    price: 140,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: ProductBuyNowScreen(product: state.product),
                      );
                    },
                  )
                :

                /// If profuct is not available then show [NotifyMeCard]
                NotifyMeCard(
                    isNotify: false,
                    onChanged: (value) {},
                  ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    floating: true,
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/icons/Bookmark.svg",
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).textTheme.bodyLarge!.color!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ProductImages(
                    images: [
                      state.product.coverUrl,
                      ...state.product.images.map((e) => e.url)
                    ],
                  ),
                  ProductInfo(
                    brand: state.product.name,
                    title: state.product.subDescription,
                    isAvailable: widget.isProductAvailable,
                    description: state.product.description,
                    rating: 4.4,
                    numOfReviews: 126,
                  ),
                  ProductListTile(
                    svgSrc: "assets/icons/Product.svg",
                    title: "Product Details",
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: const BuyFullKit(
                            images: ["assets/screens/Product detail.png"]),
                      );
                    },
                  ),
                  ProductListTile(
                    svgSrc: "assets/icons/Delivery.svg",
                    title: "Shipping Information",
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: const BuyFullKit(
                          images: ["assets/screens/Shipping information.png"],
                        ),
                      );
                    },
                  ),
                  ProductListTile(
                    svgSrc: "assets/icons/Return.svg",
                    title: "Returns",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: const ProductReturnsScreen(),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: ReviewCard(
                        rating: 4.3,
                        numOfReviews: 128,
                        numOfFiveStar: 80,
                        numOfFourStar: 30,
                        numOfThreeStar: 5,
                        numOfTwoStar: 4,
                        numOfOneStar: 1,
                      ),
                    ),
                  ),
                  ProductListTile(
                    svgSrc: "assets/icons/Chat.svg",
                    title: "Reviews",
                    isShowBottomBorder: true,
                    press: () {
                      Navigator.pushNamed(context, productReviewsScreenRoute);
                    },
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(defaultPadding),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        "You may also like",
                        style: Theme.of(context).textTheme.titleSmall!,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 220,
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, homeState) {
                          if (homeState is HomeLoading) {
                            return const ProductsSkelton();
                          } else if (homeState is HomeLoaded) {
                            final products = homeState.products[ProductFilter.popularProducts] ??
                                [];
                            if (products.isEmpty) {
                              return const Center(
                                  child: Text('No products available'));
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: products.length,
                              itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(
                                  left: defaultPadding,
                                  right: index == products.length - 1
                                      ? defaultPadding
                                      : 0,
                                ),
                                child: ProductCard(
                                  image: products[index].coverUrl,
                                  brandName: products[index].name,
                                  title: products[index].subDescription,
                                  price: products[index].priceSale ??
                                      products[index].price,
                                  priceAfetDiscount: products[index].price,
                                  dicountpercent: products[index].priceSale !=
                                          null
                                      ? ((products[index].price -
                                                  products[index].priceSale!) /
                                              products[index].price *
                                              100)
                                          .round()
                                      : 0,
                                  press: () {
                                    Navigator.pushNamed(
                                      context,
                                      productDetailsScreenRoute,
                                      arguments: {
                                        'isProductAvailable': true,
                                        'productId': products[index].id,
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          } else if (homeState is HomeError) {
                            return Center(child: Text(homeState.message));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding),
                  )
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
