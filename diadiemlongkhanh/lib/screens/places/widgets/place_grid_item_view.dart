import 'package:diadiemlongkhanh/models/remote/place_response/place_response.dart';
import 'package:diadiemlongkhanh/resources/asset_constant.dart';
import 'package:diadiemlongkhanh/resources/color_constant.dart';
import 'package:diadiemlongkhanh/routes/router_manager.dart';
import 'package:diadiemlongkhanh/utils/app_utils.dart';
import 'package:diadiemlongkhanh/widgets/cliprrect_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlaceGridItemView extends StatelessWidget {
  const PlaceGridItemView({
    Key? key,
    this.item,
  }) : super(key: key);

  final PlaceModel? item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(RouterName.detail_place),
      child: Container(
        height: 238,
        decoration: BoxDecoration(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRectImage(
                radius: 8,
                url: AppUtils.getUrlImage(
                  item!.avatar?.path ?? '',
                  width: 148,
                  height: 148,
                ),
                height: 148,
                width: double.infinity,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppUtils.getOpeningTitle(item!.openingStatus ?? ''),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    AppUtils.getDistance(item!.distance ?? 0) > 0
                        ? 'Cách ${AppUtils.getDistance(item!.distance ?? 0)}km '
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
              Text(
                item!.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: ColorConstant.neutral_black,
                ),
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
                  Text(
                    item!.region?.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10,
                        color: ColorConstant.neutral_gray_lighter),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
