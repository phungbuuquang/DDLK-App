import 'package:diadiemlongkhanh/resources/asset_constant.dart';
import 'package:diadiemlongkhanh/resources/color_constant.dart';
import 'package:diadiemlongkhanh/widgets/cliprrect_image.dart';
import 'package:diadiemlongkhanh/widgets/my_appbar.dart';
import 'package:diadiemlongkhanh/widgets/my_rating_bar.dart';
import 'package:diadiemlongkhanh/widgets/verified_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

class DetailPlaceScreen extends StatefulWidget {
  const DetailPlaceScreen({Key? key}) : super(key: key);

  @override
  _DetailPlaceScreenState createState() => _DetailPlaceScreenState();
}

class _DetailPlaceScreenState extends State<DetailPlaceScreen> {
  ScrollController scrollController = new ScrollController();
  bool isVisible = false;
  int _currentIndex = 0;
  List<String> tabMenu = [
    'Đánh giá địa điểm',
    'Thực đơn',
    'Bản đồ',
    'Thông tin liên hệ'
  ];
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isVisible)
          setState(() {
            isVisible = true;
          });
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isVisible)
          setState(() {
            isVisible = false;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.grey_F2F4F8,
      appBar: MyAppBar(
        title: 'Chi tiết địa điểm',
      ),
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: scrollController,
            // shrinkWrap: true,
            slivers: <Widget>[
              new SliverPadding(
                padding: const EdgeInsets.all(0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      Container(
                        height: 598,
                        child: Stack(children: [
                          _buildSlider(),
                          Positioned(
                            top: 248,
                            left: 0,
                            right: 0,
                            child: _buildInfoView(context),
                          ),
                        ]),
                      ),
                      _buildConveniencesView(context),
                      _buildRatingView(context),
                      _buildRangePriceView(context),
                      _buildWorkHourView(context),
                      _buildMenuView(context),
                      Container(
                        height: 265,
                        margin: const EdgeInsets.only(
                          top: 16,
                          right: 16,
                          left: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 12),
                              blurRadius: 24,
                              color:
                                  ColorConstant.grey_shadow.withOpacity(0.08),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 294,
                        margin: const EdgeInsets.only(
                          top: 16,
                          right: 16,
                          left: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 12),
                              blurRadius: 24,
                              color:
                                  ColorConstant.grey_shadow.withOpacity(0.08),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: isVisible ? 56.0 : 0.0,
            child: new Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: ListView.builder(
                  itemCount: tabMenu.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Container(
                      height: 56,
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                tabMenu[index],
                                style: _currentIndex == index
                                    ? TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor)
                                    : Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: _currentIndex == index ? 4 : 0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildMenuView(BuildContext context) {
    return Container(
      height: 144,
      margin: const EdgeInsets.only(
        top: 16,
        right: 16,
        left: 16,
      ),
      padding: const EdgeInsets.only(
        top: 16,
        right: 16,
        left: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: ColorConstant.grey_shadow.withOpacity(0.08),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thực đơn',
            style: Theme.of(context).textTheme.headline4,
          ),
          Container(
            height: 72,
            margin: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return Container(
                  height: 72,
                  width: 72,
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRectImage(
                        height: 72,
                        width: 72,
                        url:
                            'https://vuakhuyenmai.vn/wp-content/uploads/highlands-khuyen-mai-30off-8-3-2022.jpg',
                        radius: 8,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildWorkHourView(BuildContext context) {
    return Container(
      height: 116,
      margin: const EdgeInsets.only(
        top: 16,
        right: 16,
        left: 16,
      ),
      padding: const EdgeInsets.only(
        top: 16,
        right: 16,
        left: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: ColorConstant.grey_shadow.withOpacity(0.08),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Khung giờ mở cửa',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SvgPicture.asset(
                ConstantIcons.ic_chevron_right,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorConstant.neutral_gray_lightest,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Đang mở cửa',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '8:00 - 23:00',
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildRangePriceView(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(
        top: 16,
        right: 16,
        left: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: ColorConstant.grey_shadow.withOpacity(0.08),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Khoảng giá',
            style: Theme.of(context).textTheme.headline4,
          ),
          Expanded(
            child: Text(
              'Từ 50.000đ - 150.000đ',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildRatingView(BuildContext context) {
    return Container(
      height: 183,
      margin: const EdgeInsets.only(
        top: 16,
        right: 16,
        left: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: ColorConstant.grey_shadow.withOpacity(0.08),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đánh giá địa điểm',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text(
                '1600 đánh giá',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildReviewItem(),
              _buildReviewItem(),
              _buildReviewItem(),
              _buildReviewItem(),
              _buildReviewItem(),
              _buildReviewItem(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildReviewItem() {
    return UnconstrainedBox(
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ColorConstant.neutral_gray_lightest,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Vị trí',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstant.neutral_black,
                      ),
                    ),
                    TextSpan(
                      text: ' (4,5/5)',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConstant.neutral_gray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                ConstantIcons.ic_very_good,
                height: 16,
                width: 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildConveniencesView(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(
        top: 16,
        right: 16,
        left: 16,
      ),
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: ColorConstant.grey_shadow.withOpacity(0.08),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tiện ích',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Text(
                '8 tiện ích',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SvgPicture.asset(
                ConstantIcons.ic_chevron_right,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 16,
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _buildInfoView(BuildContext context) {
    return Container(
      height: 350,
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: ColorConstant.grey_shadow.withOpacity(0.08),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRectImage(
                height: 52,
                width: 52,
                radius: 26,
                url:
                    'https://dongphucbonmua.com/wp-content/uploads/2021/09/dong-phuc-highlands-coffee2-min.jpg',
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Highland Coffee',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        MyRatingBar(
                          rating: 4,
                          onRatingUpdate: (rate, isEmpty) {},
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '(1600 đánh giá)',
                          style: TextStyle(
                            fontSize: 10,
                            color: ColorConstant.neutral_gray,
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: VerifiedView(
                        margin: const EdgeInsets.only(
                          top: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    ConstantIcons.ic_book_mark,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            children: [
              SvgPicture.asset(ConstantIcons.ic_marker_filled),
              SizedBox(
                width: 10,
              ),
              Text(
                'Phường Xuân An',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                ' - Bản đồ chỉ đường',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'BHD Star Cineplex là luôn luôn bảo đảm trải nghiệm của khách hàng qua chất lượng phục vụ, ',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(height: 1.5),
          ),
          Container(
            height: 72,
            margin: const EdgeInsets.only(top: 24),
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return Container(
                  height: 72,
                  width: 72,
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRectImage(
                        height: 72,
                        width: 72,
                        url:
                            'https://vuakhuyenmai.vn/wp-content/uploads/highlands-khuyen-mai-30off-8-3-2022.jpg',
                        radius: 8,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: ColorConstant.neutral_gray_lightest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                SvgPicture.asset(ConstantIcons.ic_discountstore),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: Text(
                    '40 khuyến mãi',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  ConstantIcons.ic_chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildSlider() {
    return Container(
      height: 268,
      child: Stack(children: [
        PageView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return ClipRRectImage(
              height: double.infinity,
              width: double.infinity,
              url:
                  'https://aeonmall-haiphong-lechan.com.vn/wp-content/uploads/2020/12/hc-flagships-750x468-1.png',
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 32,
          child: Container(
            width: 52,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Text(
                '1/12',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
