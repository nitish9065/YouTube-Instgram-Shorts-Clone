import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/widgets/searchable_appbar.dart';
import 'package:shorts_clone/widgets/shimmer_grid.dart';
import 'package:shorts_clone/widgets/users_screen_helpers.dart';

import '../controllers/search_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final RxBool isSearchBar = RxBool(false);
  late TextEditingController searchText;
  late SearchScreenController searchController;
  @override
  void initState() {
    super.initState();
    searchController = Get.put(SearchScreenController());
    searchController.getAllUsers();
    searchController.searchedUser.clear();
    searchText = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchableAppbar(
            searchBarText: 'Users',
            appBarText: "Users",
            onTextEditing: (String? val) {
              if (val != null && val.isNotEmpty) {
                final user = searchController.users.where(
                    (element) => element.name.isCaseInsensitiveContains(val));
                searchController.searchedUser
                  ..clear()
                  ..addAll(user);
              } else {
                searchController.searchedUser.clear();
              }
            },
            onSubmit: (String? val) {},
            searchBarVisibilty: isSearchBar,
            controller: searchText,
            context: context,
            onClearButtonTapped: () {
              searchController.searchedUser.clear();
            }),
        body: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Obx(() => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        searchController.searchedUser.isEmpty
                            ? const SizedBox.shrink()
                            : SearcheduserView(
                                userList: searchController.searchedUser),
                        searchController.users.isEmpty
                            ? shimmerUserGrid(length: 3)
                            : Column(
                                children: [
                                  UserSuggestion(
                                      userModels: searchController.users,
                                      buttonText: 'See Profile',
                                      onButtonTap: () {},
                                      titleText: 'People You Follow'),
                                  giveSpace(height: 8),
                                  const Divider(
                                    height: 5,
                                    thickness: 10,
                                    color: Colors.black12,
                                  ),
                                  giveSpace(height: 10),
                                  UserSuggestion(
                                      userModels: searchController.users,
                                      buttonText: 'See Profile',
                                      onButtonTap: () {},
                                      titleText: 'People you should Know'),
                                ],
                              )
                      ],
                    )))));
  }
}
