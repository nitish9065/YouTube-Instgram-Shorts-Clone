import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/widgets/search_textfield.dart';

import '../strings.dart';

AppBar searchableAppbar(
    {required searchBarText,
    required String appBarText,
    required void Function(String?)? onTextEditing,
    required void Function(String?)? onSubmit,
    required RxBool searchBarVisibilty,
    required TextEditingController controller,
    required BuildContext context,
    required VoidCallback onClearButtonTapped,
    Widget? furtherActionChild}) {
  return AppBar(
    backgroundColor: Colors.purple[500],
      title: ObxValue<RxBool>(
        (isSearchBarVisible) {
          if (isSearchBarVisible.isTrue) {
            return SearchTextField(
              hintText: '${Strings.search} $searchBarText',
              textEditingController: controller,
              onTextChanged: onTextEditing ?? (query) {},
              onSubmitButton: onSubmit ?? (query) {},
            );
          } else {
            return Text(
              appBarText,
            );
          }
        },
        searchBarVisibilty,
      ),
      actions: [
        ObxValue<RxBool>(
          (isSearchBarVisible) {
            if (isSearchBarVisible.isTrue) {
              return IconButton(
                icon: const Icon(Icons.clear, color: Colors.white,),
                onPressed: () {
                  controller.clear();
                  isSearchBarVisible.toggle();
                  FocusScope.of(context).unfocus();
                  onClearButtonTapped();
                },
              );
            } else {
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white,),
                    onPressed: () => isSearchBarVisible.toggle(),
                  ),
                ],
              );
            }
          },
          searchBarVisibilty,
        ),
        furtherActionChild ?? const SizedBox.shrink()
      ],
      centerTitle: true);
}
