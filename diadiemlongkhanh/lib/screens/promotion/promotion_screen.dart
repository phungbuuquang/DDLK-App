import 'package:diadiemlongkhanh/models/remote/voucher/voucher_response.dart';
import 'package:diadiemlongkhanh/resources/asset_constant.dart';
import 'package:diadiemlongkhanh/resources/color_constant.dart';
import 'package:diadiemlongkhanh/routes/router_manager.dart';
import 'package:diadiemlongkhanh/screens/promotion/widgets/list_promotion_view.dart';
import 'package:diadiemlongkhanh/screens/skeleton_view/shimmer_image.dart';
import 'package:diadiemlongkhanh/services/api_service/api_client.dart';
import 'package:diadiemlongkhanh/services/di/di.dart';
import 'package:diadiemlongkhanh/utils/app_utils.dart';
import 'package:diadiemlongkhanh/widgets/cliprrect_image.dart';
import 'package:diadiemlongkhanh/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({Key? key}) : super(key: key);

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  List<String> filterDatas = ['Tất cả', 'Cơm', 'Bún', 'Phở'];
  int _indexFilter = 0;
  List<VoucherModel> vouchers = [];
  VoucherModel? firstItem;
  @override
  void initState() {
    super.initState();
    _getPromotions();
  }

  _getPromotions() async {
    final res = await injector.get<ApiClient>().getVouchers();
    if (res != null) {
      setState(() {
        vouchers = res;
        if (vouchers.isNotEmpty) {
          firstItem = vouchers.removeAt(0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.grey_F2F4F8,
      appBar: MyAppBar(
        title: 'Khuyến mãi',
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                ConstantImages.left_pin,
                width: 153,
                height: 116,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeaderPromotionVie(context),
                    // _buildFilterPromotionView(),
                    _buildListPromotionView(context)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderPromotionVie(BuildContext context) {
    return Container(
      height: 280,
      margin: const EdgeInsets.only(
        top: 28,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.green_shadow.withOpacity(0.12),
            offset: Offset(0, 15),
            blurRadius: 40,
          )
        ],
      ),
      child: firstItem == null
          ? ShimmerImage()
          : GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                RouterName.detail_promotion,
                arguments: firstItem!.id,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRectImage(
                    radius: 8,
                    height: 189,
                    width: double.infinity,
                    url: AppUtils.getUrlImage(
                      firstItem!.thumbnail?.path ?? '',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem!.place?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          firstItem!.place?.address?.specific ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstant.neutral_gray,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          firstItem!.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorConstant.orange_secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildListPromotionView(BuildContext context) {
    return ListPromotionView(
      margin: const EdgeInsets.only(top: 24),
      vouhchers: vouchers,
    );
  }

  Container _buildFilterPromotionView() {
    return Container(
      height: 28,
      margin: const EdgeInsets.only(
        top: 48,
        left: 16,
        right: 16,
      ),
      child: ListView.builder(
        itemCount: filterDatas.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return Container(
            height: 28,
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: index == _indexFilter
                  ? ColorConstant.green_D5F4D9
                  : Colors.transparent,
            ),
            child: Center(
              child: Text(
                filterDatas[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      index == _indexFilter ? FontWeight.w500 : FontWeight.w400,
                  color: index == _indexFilter
                      ? Theme.of(context).primaryColor
                      : ColorConstant.neutral_gray,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
