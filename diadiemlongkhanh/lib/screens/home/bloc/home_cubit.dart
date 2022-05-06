import 'package:diadiemlongkhanh/models/remote/category/category_response.dart';
import 'package:diadiemlongkhanh/models/remote/new_feed/new_feed_response.dart';
import 'package:diadiemlongkhanh/models/remote/place_response/place_response.dart';
import 'package:diadiemlongkhanh/models/remote/slide/slide_response.dart';
import 'package:diadiemlongkhanh/models/remote/voucher/voucher_response.dart';
import 'package:diadiemlongkhanh/services/api_service/api_client.dart';
import 'package:diadiemlongkhanh/services/di/di.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  int subCategoryIndex = 0;
  List<CategoryModel> subCategories = [];

  getSlides() async {
    final res = await injector.get<ApiClient>().getSlides();
    if (res != null) {
      emit(HomeGetSlideDoneState(res));
    }
  }

  getPlacesNear() async {
    final res = await injector.get<ApiClient>().getPlacesNear(
          10.9238253,
          107.1943696,
          5,
        );
    if (res != null) {
      emit(HomeGetPlaceNearDoneState(res));
    }
  }

  getPlacesHot() async {
    final res = await injector.get<ApiClient>().getPlacesHot();
    if (res != null) {
      emit(HomeGetPlaceHotDoneState(res));
    }
  }

  getVouchers() async {
    final res = await injector.get<ApiClient>().getVouchers();
    if (res != null) {
      emit(HomeGetVouchersDoneState(res));
    }
  }

  getSubCategories() async {
    final res = await injector.get<ApiClient>().getSubCategories();
    if (res != null) {
      subCategories = res;
      if (subCategories.length > 0) {
        final total = CategoryModel();
        total.id = '';
        total.name = 'Tất cả';
        subCategories.insert(0, total);
      }
      emit(HomeGetSubCategoriesDoneState());
      getPlacesNew('');
    }
  }

  selectSubCategory(int index) {
    subCategoryIndex = index;
    emit(
      HomeSelectSubCategoryState(),
    );
    getPlacesNew(subCategories[index].id ?? '');
  }

  getPlacesNew(String subCategory) async {
    final res = await injector.get<ApiClient>().getPlacesNew(
          subCategory: subCategory,
          limit: 6,
        );
    if (res != null) {
      emit(HomeGetPlaceNewDoneState(res));
    }
  }

  getNewFeeds() async {
    final res = await injector.get<ApiClient>().getExploresNew();
    if (res != null) {
      emit(HomeGetNewFeedsDoneState(res));
    }
  }
}