import 'package:diadiemlongkhanh/config/env_config.dart';
import 'package:diadiemlongkhanh/models/local/report_type_model.dart';
import 'package:diadiemlongkhanh/models/remote/category/category_response.dart';
import 'package:diadiemlongkhanh/models/remote/new_feed/new_feed_response.dart';
import 'package:diadiemlongkhanh/models/remote/place_response/place_response.dart';
import 'package:diadiemlongkhanh/models/remote/slide/slide_response.dart';
import 'package:diadiemlongkhanh/models/remote/voucher/voucher_response.dart';
import 'package:diadiemlongkhanh/resources/asset_constant.dart';
import 'package:diadiemlongkhanh/resources/color_constant.dart';
import 'package:diadiemlongkhanh/routes/router_manager.dart';
import 'package:diadiemlongkhanh/screens/home/bloc/home_cubit.dart';
import 'package:diadiemlongkhanh/screens/home/widgets/custom_slider_view.dart';
import 'package:diadiemlongkhanh/screens/new_feeds/widgets/new_feed_item_view.dart';
import 'package:diadiemlongkhanh/screens/places/widgets/place_action_dialog.dart';
import 'package:diadiemlongkhanh/screens/places/widgets/place_horiz_item_view.dart';
import 'package:diadiemlongkhanh/screens/places/widgets/places_grid_view.dart';
import 'package:diadiemlongkhanh/services/di/di.dart';
import 'package:diadiemlongkhanh/services/storage/storage_service.dart';
import 'package:diadiemlongkhanh/utils/app_utils.dart';
import 'package:diadiemlongkhanh/utils/global_value.dart';
import 'package:diadiemlongkhanh/widgets/cliprrect_image.dart';
import 'package:diadiemlongkhanh/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  HomeCubit get _cubit => BlocProvider.of(context);
  final bool _isScroll = true;
  final _refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getData();
    });
  }

  getData() async {
    _cubit.getAllData();
    _refreshController.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
            ),
            child: Column(
              children: [
                _buildHeaderView(),
                _buildSearchView(context),
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    onRefresh: getData,
                    header: const WaterDropMaterialHeader(),
                    child: SingleChildScrollView(
                      physics: _isScroll
                          ? const ScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          _buildSliderView(),
                          const SizedBox(
                            height: 20,
                          ),
                          _buildMenuView(),
                          const SizedBox(
                            height: 37,
                          ),
                          BlocBuilder<HomeCubit, HomeState>(
                            buildWhen: (previous, current) =>
                                current is HomeGetPlaceNearDoneState,
                            builder: (_, state) {
                              List<PlaceModel> places = [];
                              if (state is HomeGetPlaceNearDoneState) {
                                places = state.places;
                              }
                              return _buildListHorizontalSingleView(
                                title: 'Địa điểm gần bạn',
                                places: places,
                                nextToAll: () => _cubit.nextToAllPlaceNear(
                                  context,
                                  isNear: true,
                                ),
                              );
                            },
                          ),
                          BlocBuilder<HomeCubit, HomeState>(
                            buildWhen: (previous, current) =>
                                current is HomeGetPlaceHotDoneState,
                            builder: (_, state) {
                              List<PlaceModel> places = [];
                              if (state is HomeGetPlaceHotDoneState) {
                                places = state.places;
                              }
                              return _buildListHorizontalSingleView(
                                  title: 'Tìm kiếm nhiều nhất',
                                  places: places,
                                  nextToAll: () => _cubit.nextToAllPlaceNear(
                                        context,
                                        sort: 'view',
                                      ));
                            },
                          ),
                          _buildPromotionListView(),
                          _buildGridView(context),
                          Container(
                            height: 15,
                            color: ColorConstant.neutral_gray_lightest,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Column(
                              children: [
                                _buildHeaderSection(
                                  'Khám phá',
                                  showIcon: false,
                                ),
                                _buildListNewFeedsView(),
                                MainButton(
                                  title: 'KHÁM PHÁ THÊM',
                                  onPressed: () =>
                                      Navigator.of(context).pushNamed(
                                    RouterName.new_feeds,
                                    arguments: true,
                                  ),
                                  margin: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    bottom: 30,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListNewFeedsView() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is HomeGetNewFeedsDoneState,
      builder: (_, state) {
        List<NewFeedModel> newfeeds = _cubit.reviews;

        return ListView.builder(
          itemCount: newfeeds.isEmpty ? 5 : newfeeds.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          itemBuilder: (_, index) {
            final item = newfeeds.isEmpty ? null : newfeeds[index];
            return NewFeedItemView(
              item: item,
              moreSelect: () {
                if (item == null) return;
                AppUtils.showBottomDialog(
                  context,
                  PlaceActionDiaglog(
                    type: ReportType.review,
                    docId: newfeeds[index].id,
                  ),
                );
              },
              isShowComment: injector.get<StorageService>().getToken() != null,
              nextToDetail: () {
                if (item == null) return;
                Navigator.of(context).pushNamed(
                  RouterName.detail_review,
                  arguments: newfeeds[index],
                );
              },
              likePressed: () {
                if (item == null) return;
                _cubit.likePost(
                  context,
                  index,
                );
              },
              sendComment: () {
                if (item == null) return;
                _cubit.sendComment(index);
              },
            );
          },
        );
      },
    );
  }

  Column _buildGridView(BuildContext context) {
    return Column(
      children: [
        _buildHeaderSection(
          'Địa điểm mới cập nhật',
          nextToAll: () => _cubit.nextToAllPlaceNear(
            context,
            sort: 'createdAt',
          ),
        ),
        _buildListSubCategoriesView(context),
        BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) => current is HomeGetPlaceNewDoneState,
          builder: (_, state) {
            List<PlaceModel> places = [];
            if (state is HomeGetPlaceNewDoneState) {
              places = state.places;
            }
            return PlacesGridView(
              places: places,
              physics: const NeverScrollableScrollPhysics(),
              onSelect: (item) => Navigator.of(context).pushNamed(
                RouterName.detail_place,
                arguments: item.id,
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildListSubCategoriesView(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeGetSubCategoriesDoneState ||
          current is HomeSelectSubCategoryState,
      builder: (_, state) {
        return Container(
          height: 28,
          margin: const EdgeInsets.only(top: 24),
          child: ListView.builder(
              itemCount: _cubit.subCategories.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              itemBuilder: (_, index) {
                final item = _cubit.subCategories[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _cubit.selectSubCategory(index),
                  child: Container(
                    height: 28,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: index == _cubit.subCategoryIndex
                          ? ColorConstant.green_D5F4D9
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        item.name ?? '',
                        style: index == _cubit.subCategoryIndex
                            ? TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              )
                            : Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  Widget _buildPromotionListView() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is HomeGetVouchersDoneState,
      builder: (_, state) {
        List<VoucherModel> vouchers = [];
        if (state is HomeGetVouchersDoneState) {
          vouchers = state.vouchers;
        }
        return Container(
          height: 250,
          margin: const EdgeInsets.only(bottom: 40),
          decoration: const BoxDecoration(
            color: ColorConstant.grey_F1F5F2,
            image: DecorationImage(
              image: AssetImage(ConstantImages.world_map),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              _buildHeaderSection(
                'Khuyến mãi Hot',
                nextToAll: () =>
                    Navigator.of(context).pushNamed(RouterName.promotion),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: vouchers.isEmpty ? 5 : vouchers.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    itemBuilder: (_, index) {
                      VoucherModel? item =
                          vouchers.isEmpty ? null : vouchers[index];
                      return Container(
                        width: 218,
                        margin: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (item == null) return;
                            Navigator.of(context).pushNamed(
                              RouterName.detail_promotion,
                              arguments: vouchers[index].id,
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRectImage(
                                radius: 12,
                                url: item == null
                                    ? ''
                                    : AppUtils.getUrlImage(
                                        item.thumbnail?.path ?? '',
                                        height: 122,
                                      ),
                                height: 122,
                                width: 218,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                item?.title ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                item?.content ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: ColorConstant.orange_secondary,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(
    String title, {
    bool showIcon = true,
    Function()? nextToAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          showIcon
              ? InkWell(
                  onTap: nextToAll,
                  child: SvgPicture.asset(
                    ConstantIcons.ic_chevron_right,
                    width: 30,
                    height: 30,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildListHorizontalSingleView({
    required String title,
    required List<PlaceModel> places,
    Function()? nextToAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderSection(
          title,
          nextToAll: nextToAll,
        ),
        SizedBox(
          height: 314,
          child: ListView.builder(
            itemCount: places.isEmpty ? 5 : places.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              bottom: 40,
            ),
            itemBuilder: (_, index) {
              return PlaceHorizItemView(
                context: context,
                item: places.isEmpty ? null : places[index],
                onPressed: () {
                  if (places.isEmpty) return;
                  injector
                      .get<StorageService>()
                      .savePlaceIds(places[index].id ?? '');
                  Navigator.of(context).pushNamed(
                    RouterName.detail_place,
                    arguments: places[index].id ?? '',
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  Container _buildMenuView() {
    return Container(
      height: 196,
      margin: const EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 15),
            blurRadius: 40,
            color: ColorConstant.grey_shadow.withOpacity(0.12),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuItem(
                title: 'Gần đây',
                onPressed: () => _cubit.nextToAllPlaceNear(
                  context,
                  isNear: true,
                ),
                icon: Image.asset(
                  ConstantIcons.ic_map,
                  width: 46,
                  height: 37,
                ),
              ),
              _buildMenuItem(
                title: 'Khám phá',
                onPressed: () => Navigator.of(context).pushNamed(
                  RouterName.new_feeds,
                  arguments: true,
                ),
                icon: Image.asset(
                  ConstantIcons.ic_binoculars,
                  width: 41,
                  height: 37,
                ),
              ),
              _buildMenuItem(
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouterName.promotion),
                title: 'Khuyến mãi',
                icon: Image.asset(
                  ConstantIcons.ic_promotion,
                  width: 44,
                  height: 37,
                ),
              ),
              _buildMenuItem(
                title: 'Ăn uống',
                onPressed: () => Navigator.of(context).pushNamed(
                  RouterName.list_places,
                  arguments: {
                    'category': CategoryModel(
                      id: Environment().config.categoryStatic.food,
                    ),
                  },
                ),
                icon: Image.asset(
                  ConstantIcons.ic_food,
                  width: 42,
                  height: 37,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuItem(
                title: 'Giải trí',
                onPressed: () => Navigator.of(context).pushNamed(
                  RouterName.list_places,
                  arguments: {
                    'category': CategoryModel(
                      id: Environment().config.categoryStatic.entertainment,
                    ),
                  },
                ),
                icon: Image.asset(
                  ConstantIcons.ic_store,
                  width: 45,
                  height: 33,
                ),
              ),
              _buildMenuItem(
                title: 'Khách sạn',
                onPressed: () => Navigator.of(context).pushNamed(
                  RouterName.list_places,
                  arguments: {
                    'category': CategoryModel(
                      id: Environment().config.categoryStatic.hotel,
                    ),
                  },
                ),
                icon: Image.asset(
                  ConstantIcons.ic_hotel,
                  width: 45,
                  height: 49,
                ),
              ),
              _buildMenuItem(
                title: 'Du lịch',
                onPressed: () => Navigator.of(context).pushNamed(
                  RouterName.list_places,
                  arguments: {
                    'category': CategoryModel(
                      id: Environment().config.categoryStatic.travel,
                    ),
                  },
                ),
                icon: Image.asset(
                  ConstantIcons.ic_travel,
                  width: 37,
                  height: 42,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    Function()? onPressed,
    Widget? icon,
    required String title,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: 56,
            width: 56,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: ColorConstant.grey_F8F9FA,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: icon,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: ColorConstant.neutral_black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderView() {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is HomeGetSlideDoneState,
      builder: (_, state) {
        List<SlideModel> slides = [];
        if (state is HomeGetSlideDoneState) {
          slides = state.slides;
        }
        return CustomSliderView(
          datas: slides,
        );
      },
    );
  }

  Widget _buildSearchView(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pushNamed(RouterName.search),
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: ColorConstant.neutral_gray_lightest,
        ),
        child: Row(
          children: [
            SvgPicture.asset(ConstantIcons.ic_search),
            const SizedBox(
              width: 16,
            ),
            Text(
              'Tìm kiếm mọi thứ',
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderView() {
    final token = injector.get<StorageService>().getToken();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          token == null
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      RouterName.option_login,
                      arguments: true,
                    ),
                    child: Text(
                      'Đăng nhập/Đăng ký',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                )
              : BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) =>
                      current is HomeGetProfileDoneState,
                  builder: (_, state) {
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(context).pushNamed(
                          RouterName.account,
                        ),
                        child: Row(
                          children: [
                            ClipRRectImage(
                              height: 44,
                              width: 44,
                              radius: 22,
                              url: AppUtils.getUrlImage(
                                GlobalValue.avatar ?? '',
                                width: 44,
                                height: 44,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                GlobalValue.name ?? '',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          _buildNotiButton()
        ],
      ),
    );
  }

  GestureDetector _buildNotiButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(RouterName.notification),
      child: SizedBox(
        height: 36,
        width: 36,
        child: Stack(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: ColorConstant.neutral_gray_lightest,
              ),
              child: Center(
                child: SvgPicture.asset(ConstantIcons.ic_bell),
              ),
            ),
            Positioned(
              top: 2,
              right: 0,
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: ColorConstant.sematic_red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
