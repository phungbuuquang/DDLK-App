import 'package:diadiemlongkhanh/resources/asset_constant.dart';
import 'package:diadiemlongkhanh/resources/color_constant.dart';
import 'package:diadiemlongkhanh/screens/promotion/code_promotion_dialog.dart';
import 'package:diadiemlongkhanh/screens/promotion/widgets/list_promotion_view.dart';
import 'package:diadiemlongkhanh/widgets/cliprrect_image.dart';
import 'package:diadiemlongkhanh/widgets/line_dashed_painter.dart';
import 'package:diadiemlongkhanh/widgets/my_appbar.dart';
import 'package:diadiemlongkhanh/widgets/my_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailPromotionScreen extends StatefulWidget {
  const DetailPromotionScreen({Key? key}) : super(key: key);

  @override
  State<DetailPromotionScreen> createState() => _DetailPromotionScreenState();
}

class _DetailPromotionScreenState extends State<DetailPromotionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.grey_F2F4F8,
      appBar: MyAppBar(
        title: 'Chi tiết khuyến mãi',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVoucherView(),
                    _buildContentView(context),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'Các khuyến mãi khác',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    ListPromotionView(
                      margin: const EdgeInsets.only(top: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildContentView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 15),
            blurRadius: 40,
            color: ColorConstant.green_shadow.withOpacity(0.12),
          )
        ],
      ),
      child: Text(
        '-  Từ ngày 12-12-2022 đến 12-01-2023 giảm 30% khi thanh toán tại Mono Coffee Lab\n-  Áp dụng toàn bộ menu tại Mono Coffee Lab\n-  Không áp dụng ngày lễ',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Container _buildVoucherView() {
    return Container(
      height: 480,
      child: Stack(
        children: [
          ClipRRectImage(
            radius: 8,
            height: 286,
            width: double.infinity,
            url:
                'https://img.giftpop.vn/brand/GOGIHOUSE/MP1905280011_BASIC_origin.jpg',
          ),
          Positioned(
            top: 250,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  height: 229,
                  child: Column(
                    children: [
                      Container(
                        height: 152,
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 16,
                          right: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, -4),
                              blurRadius: 8,
                              color:
                                  ColorConstant.green_shadow.withOpacity(0.12),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Giảm giá 30%',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: ColorConstant.orange_secondary,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Mono Coffee Lab',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: InkWell(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (_) => CodePromotionDialog(),
                                    ),
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            ConstantIcons.ic_qr,
                                            height: 24,
                                            width: 24,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Lấy mã giảm giá',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                ?.apply(
                                                  color: Colors.white,
                                                ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color:
                                          ColorConstant.neutral_gray_lightest,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Lưu',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: LineDashedPainter(
                            isHorizontal: false,
                          ),
                        ),
                      ),
                      Container(
                        height: 76,
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 8),
                              blurRadius: 16,
                              color:
                                  ColorConstant.green_shadow.withOpacity(0.12),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRectImage(
                              radius: 22,
                              url:
                                  'https://upload.wikimedia.org/wikipedia/commons/8/89/Chris_Evans_2020_%28cropped%29.jpg',
                              height: 44,
                              width: 44,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mono Coffee Lab',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '4.0',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant
                                              .neutral_gray_lighter,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      MyRatingBar(
                                        rating: 4,
                                        onRatingUpdate: (rate, isEmpty) {},
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Mở cửa',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 98,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    ConstantIcons.ic_book_mark,
                                    width: 11,
                                    height: 14,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Lưu địa điểm',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
