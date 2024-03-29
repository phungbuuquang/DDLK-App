import 'package:diadiemlongkhanh/models/remote/comment/comment_response.dart';
import 'package:diadiemlongkhanh/models/remote/new_feed/new_feed_response.dart';
import 'package:diadiemlongkhanh/models/remote/thumnail/thumbnail_model.dart';
import 'package:diadiemlongkhanh/resources/asset_constant.dart';
import 'package:diadiemlongkhanh/resources/color_constant.dart';
import 'package:diadiemlongkhanh/routes/router_manager.dart';
import 'package:diadiemlongkhanh/services/di/di.dart';
import 'package:diadiemlongkhanh/services/storage/storage_service.dart';
import 'package:diadiemlongkhanh/utils/app_utils.dart';
import 'package:diadiemlongkhanh/utils/global_value.dart';
import 'package:diadiemlongkhanh/widgets/cliprrect_image.dart';
import 'package:diadiemlongkhanh/widgets/full_image_view.dart';
import 'package:diadiemlongkhanh/widgets/main_text_form_field.dart';
import 'package:diadiemlongkhanh/widgets/my_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';

class NewFeedItemView extends StatelessWidget {
  final bool isShowComment;
  final Function()? nextToDetail;
  final NewFeedModel? item;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final List<CommentModel>? comments;
  final Function()? likePressed;
  final Function()? sendComment;
  final Function(int)? likeComment;
  final Function()? moreSelect;
  final bool disablNextProfile;

  NewFeedItemView({
    this.isShowComment = false,
    this.nextToDetail,
    this.item,
    this.margin,
    this.decoration,
    this.comments,
    this.likePressed,
    this.sendComment,
    this.likeComment,
    this.moreSelect,
    this.disablNextProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
        bottom: 16,
      ),
      margin: margin != null
          ? margin
          : const EdgeInsets.only(
              bottom: 16,
              left: 16,
              right: 16,
            ),
      decoration: decoration != null
          ? decoration
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ColorConstant.grey_shadow.withOpacity(0.12),
                  offset: Offset(0, 12),
                  blurRadius: 40,
                )
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderView(context),
          SizedBox(
            height: 8,
          ),
          // GestureDetector(
          //   onTap: nextToDetail,
          //   child: Text(
          //     item!.content ?? '',
          //     style: Theme.of(context).textTheme.bodyText1,
          //   ),
          // ),
          GestureDetector(
            onTap: nextToDetail,
            child: ReadMoreText(
              item?.content ?? '',
              trimLines: 3,
              colorClickableText: Theme.of(context).primaryColor,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Xem thêm',
              trimExpandedText: 'Ẩn bớt',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          _buildPhotosView(context),
          _buildInfoView(context),
          _buildBehaviorView(),

          isShowComment ? _buildInputCommentField(context) : SizedBox.shrink(),
          comments != null ? _buildListCommentView(context) : SizedBox.shrink(),
          // SizedBox(
          //   height: (item!.commentCount ?? 0) > 0 ? 24 : 0,
          // ),
          // (item!.commentCount ?? 0) > 0
          //     ? Center(
          //         child: Text(
          //           'Xem tất cả ${item!.commentCount ?? 0} bình luận',
          //           style: Theme.of(context).textTheme.headline2,
          //         ),
          //       )
          //     : SizedBox.shrink()
        ],
      ),
    );
  }

  ListView _buildListCommentView(BuildContext context) {
    final _comments = comments ?? [];
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: _comments.length,
      padding: const EdgeInsets.only(
        top: 16,
      ),
      shrinkWrap: true,
      itemBuilder: (_, index) {
        final item = _comments[index];
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 18,
          ),
          child: Row(
            children: [
              ClipRRectImage(
                radius: 18,
                onPressed: () => Navigator.of(context).pushNamed(
                  RouterName.account,
                  arguments: item.author?.id,
                ),
                url: item.author?.avatar ?? '',
                width: 36,
                height: 36,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorConstant.neutral_gray_lightest,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                              RouterName.account,
                              arguments: item.author?.id,
                            ),
                            child: Text(
                              item.author?.name ?? '',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            item.content ?? '',
                            maxLines: null,
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorConstant.neutral_black,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          AppUtils.convertDatetimePrefix(item.createdAt ?? ''),
                          style: TextStyle(
                            fontSize: 10,
                            color: ColorConstant.neutral_gray,
                          ),
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (likeComment != null) {
                              likeComment!(index);
                            }
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                item.isLiked
                                    ? ConstantIcons.ic_heart
                                    : ConstantIcons.ic_heart_outline,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${item.likeCount} Thích',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: ColorConstant.neutral_gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        // Text(
                        //   'Trả lời',
                        //   style: TextStyle(
                        //     fontSize: 10,
                        //     color: ColorConstant.neutral_gray,
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputCommentField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          ClipRRectImage(
            radius: 18,
            url: AppUtils.getUrlImage(
              GlobalValue.avatar ?? '',
              width: 100,
              height: 100,
            ),
            width: 36,
            height: 36,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: SizedBox(
              height: 36,
              child: MainTextFormField(
                hintText: 'Viết bình luận',
                controller: item?.controller,
                colorBorder: ColorConstant.neutral_gray_lightest,
                radius: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              if (sendComment != null) {
                sendComment!();
              }
            },
            child: SvgPicture.asset(
              ConstantIcons.ic_send,
            ),
          )
        ],
      ),
    );
  }

  Container _buildBehaviorView() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.neutral_gray_lightest,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: likePressed,
            child: Row(
              children: [
                item == null
                    ? SizedBox.shrink()
                    : SvgPicture.asset(
                        item!.isLiked
                            ? ConstantIcons.ic_heart
                            : ConstantIcons.ic_heart_outline,
                      ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${item?.likeCount ?? 0} Thích',
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorConstant.neutral_gray,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 18,
          ),
          GestureDetector(
            onTap: nextToDetail,
            child: Row(
              children: [
                SvgPicture.asset(ConstantIcons.ic_comment),
                SizedBox(
                  width: 6,
                ),
                Text(
                  '${item?.commentCount ?? 0} Bình luận',
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorConstant.neutral_gray,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _nextToDetailPlace(BuildContext context) async {
    if (item == null) return;
    injector.get<StorageService>().savePlaceIds(item?.place?.id ?? '');
    Navigator.of(context)
        .pushNamed(RouterName.detail_place, arguments: item?.place?.id);
  }

  Widget _buildInfoView(BuildContext context) {
    return GestureDetector(
      onTap: () => _nextToDetailPlace(context),
      child: Container(
        height: 82,
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ColorConstant.green_primary,
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.16),
          //   ),
          //   BoxShadow(
          //     color: Colors.white,
          //     blurRadius: 16.0,
          //   ),
          // ],
        ),
        child: Row(
          children: [
            ClipRRectImage(
              radius: 4,
              url: item == null
                  ? ''
                  : AppUtils.getUrlImage(
                      item!.place?.avatar?.path ?? '',
                      width: 200,
                      height: 200,
                    ),
              width: 64,
              height: 64,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item?.place?.name ?? '',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppUtils.getDistance(item?.place?.distance ?? 0) > 0
                            ? 'Cách ${AppUtils.getDistance(item?.place?.distance ?? 0)}km '
                            : '',
                        style: TextStyle(
                          fontSize: 10,
                          color: ColorConstant.neutral_gray,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        ConstantIcons.ic_marker_grey,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          item?.place?.address?.specific ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorConstant.neutral_gray_lighter),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Text(
                        AppUtils.roundedRating(item?.place?.avgRate ?? 0)
                            .toString(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: ColorConstant.neutral_gray_lighter,
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      MyRatingBar(
                        rating: item?.place?.avgRate ?? 0,
                        onRatingUpdate: (rate, isEmpty) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoublePhotoView(
    BuildContext context,
    List<ThumbnailModel> images,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: ClipRRectImage(
            radius: 8,
            url: AppUtils.getUrlImage(images.first.path ?? '',
                height: 218, width: screenWidth / 2),
            height: double.infinity,
            onPressed: () => AppUtils.showBottomDialog(
              context,
              FullImageView(
                images.map((e) => e.path ?? '').toList(),
                currentIndex: 0,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: ClipRRectImage(
            radius: 8,
            url: AppUtils.getUrlImage(
              images.last.path ?? '',
              height: 218,
              width: screenWidth / 2,
            ),
            height: double.infinity,
            onPressed: () => AppUtils.showBottomDialog(
              context,
              FullImageView(
                images.map((e) => e.path ?? '').toList(),
                currentIndex: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThreePhotoView(
    BuildContext context,
    List<ThumbnailModel> images,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
          child: ClipRRectImage(
            radius: 8,
            url: AppUtils.getUrlImage(
              images.first.path ?? '',
              height: 218,
              width: screenWidth / 2,
            ),
            height: double.infinity,
            onPressed: () => AppUtils.showBottomDialog(
              context,
              FullImageView(
                images.map((e) => e.path ?? '').toList(),
                currentIndex: 0,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ClipRRectImage(
                  radius: 8,
                  url: AppUtils.getUrlImage(
                    images[1].path ?? '',
                    height: 107,
                    width: screenWidth / 2,
                  ),
                  width: double.infinity,
                  onPressed: () => AppUtils.showBottomDialog(
                    context,
                    FullImageView(
                      images.map((e) => e.path ?? '').toList(),
                      currentIndex: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: ClipRRectImage(
                  radius: 8,
                  url: AppUtils.getUrlImage(
                    images.last.path ?? '',
                    height: 107,
                    width: screenWidth / 2,
                  ),
                  width: double.infinity,
                  onPressed: () => AppUtils.showBottomDialog(
                    context,
                    FullImageView(
                      images.map((e) => e.path ?? '').toList(),
                      currentIndex: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFourPhotoView(
    BuildContext context,
    List<ThumbnailModel> images, {
    bool isMulti = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ClipRRectImage(
                  radius: 8,
                  url: AppUtils.getUrlImage(
                    images.first.path ?? '',
                    width: screenWidth / 2,
                    height: 107,
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  onPressed: () => AppUtils.showBottomDialog(
                    context,
                    FullImageView(
                      images.map((e) => e.path ?? '').toList(),
                      currentIndex: 0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: ClipRRectImage(
                  radius: 8,
                  url: AppUtils.getUrlImage(
                    images[1].path ?? '',
                    width: screenWidth / 2,
                    height: 107,
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  onPressed: () => AppUtils.showBottomDialog(
                    context,
                    FullImageView(
                      images.map((e) => e.path ?? '').toList(),
                      currentIndex: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ClipRRectImage(
                  radius: 8,
                  url: AppUtils.getUrlImage(
                    images[2].path ?? '',
                    width: screenWidth / 2,
                    height: 107,
                  ),
                  // width: double.infinity,
                  // height: double.infinity,
                  onPressed: () => AppUtils.showBottomDialog(
                    context,
                    FullImageView(
                      images.map((e) => e.path ?? '').toList(),
                      currentIndex: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Stack(
                  children: [
                    ClipRRectImage(
                      radius: 8,
                      url: AppUtils.getUrlImage(
                        images[3].path ?? '',
                        width: screenWidth / 2,
                        height: 107,
                      ),
                      width: double.infinity,
                      height: double.infinity,
                      onPressed: () => AppUtils.showBottomDialog(
                        context,
                        FullImageView(
                          images.map((e) => e.path ?? '').toList(),
                          currentIndex: 3,
                        ),
                      ),
                    ),
                    isMulti
                        ? GestureDetector(
                            onTap: () => AppUtils.showBottomDialog(
                              context,
                              FullImageView(
                                images.map((e) => e.path ?? '').toList(),
                                currentIndex: 3,
                              ),
                            ),
                            child: Container(
                              // height: double.infinity,
                              // width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '+${images.length - 3}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Container _buildPhotosView(BuildContext context) {
    final images = item?.images ?? [];
    Widget photoView = SizedBox.shrink();

    switch (images.length) {
      case 0:
        photoView = SizedBox.shrink();
        break;
      case 1:
        photoView = ClipRRectImage(
          radius: 8,
          url: AppUtils.getUrlImage(
            images.first.path ?? '',
            width: MediaQuery.of(context).size.width,
            height: 218,
          ),
          width: double.infinity,
          height: double.infinity,
          onPressed: () => AppUtils.showBottomDialog(
            context,
            FullImageView(
              images.map((e) => e.path ?? '').toList(),
              currentIndex: 0,
            ),
          ),
        );
        break;
      case 2:
        photoView = _buildDoublePhotoView(context, images);
        break;
      case 3:
        photoView = _buildThreePhotoView(context, images);
        break;
      case 4:
        photoView = _buildFourPhotoView(context, images);
        break;
      default:
        photoView = _buildFourPhotoView(
          context,
          images,
          isMulti: true,
        );
    }
    return Container(
      height: images.isEmpty ? 0 : 218,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      child: photoView,
    );
  }

  _nexToInfoUser(BuildContext context) {
    if (item == null) return;
    if (disablNextProfile) {
      return;
    }
    if (item?.anonymous == true) {
      return;
    }
    Navigator.of(context).pushNamed(
      RouterName.account,
      arguments: item!.author?.id,
    );
  }

  Row _buildHeaderView(BuildContext context) {
    return Row(
      children: [
        ClipRRectImage(
          radius: 22,
          url: item == null
              ? ''
              : AppUtils.getUrlImage(
                  item!.author?.avatar ?? '',
                  width: 100,
                  height: 100,
                ),
          width: 44,
          height: 44,
          onPressed: () => _nexToInfoUser(context),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _nexToInfoUser(context),
                    child: Text(
                      item?.author?.name ?? '',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  SvgPicture.asset(
                    ConstantIcons.ic_right,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () => _nextToDetailPlace(context),
                      child: Text(
                        item?.place?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Text(
                    AppUtils.roundedRating(item?.rateAvg ?? 0).toString(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.neutral_gray_lighter,
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  MyRatingBar(
                    rating: item?.rateAvg ?? 0,
                    onRatingUpdate: (rate, isEmpty) {},
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 5,
                      right: 8,
                    ),
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                      color: ColorConstant.neutral_gray_lighter,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  GestureDetector(
                    onTap: nextToDetail,
                    child: Text(
                      item == null
                          ? ''
                          : AppUtils.convertDatetimePrefix(
                              item?.createdAt ?? ''),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.neutral_gray_lighter,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        _buildFollowButton(context),
      ],
    );
  }

  Widget _buildFollowButton(BuildContext context) {
    return GestureDetector(
      onTap: moreSelect,
      child: Container(
        height: 24,
        width: 24,
        child: Icon(Icons.more_horiz),
      ),
    );
  }
}
