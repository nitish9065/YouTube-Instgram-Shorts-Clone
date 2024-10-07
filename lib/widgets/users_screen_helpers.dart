import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/controllers/auth_controller.dart';
import 'package:shorts_clone/models/user_model.dart';
import 'package:shorts_clone/screens/profile_screen.dart';
import 'package:shorts_clone/widgets/user_suggestion_card.dart';
import '../common.dart';

class UserSuggestion extends StatelessWidget {
   UserSuggestion(
      {super.key,
      required this.userModels,
      required this.buttonText,
      required this.onButtonTap,
      required this.titleText,
      this.axis = Axis.vertical,
      this.shrinkWrap = true,
      this.physics = const NeverScrollableScrollPhysics()
      });

  final List<UserModel> userModels;
  final String buttonText;
  final VoidCallback onButtonTap;
  final String titleText;
  final Axis? axis;
  final bool? shrinkWrap;
  final ScrollPhysics? physics;
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleText,
              style: Get.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.arrow_forward,
                  size: 18,
                ))
          ],
        ),
        giveSpace(height: 8),
        const Divider(
          height: 4,
        ),
        GridView.builder(
            scrollDirection: axis!,
            shrinkWrap: shrinkWrap!,
            physics: physics,
            itemCount: userModels.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                mainAxisExtent: Get.height/3.5
                ),
            itemBuilder: (context, index) {
              final user = userModels[index];
              return userSuggestionCard(user: user, buttonText: buttonText, onTap: (){
                      Get.to(ProfileScreen(uid: user.uid, isFromSamePage: false,));
              });
            })
      ],
    );
  }
}

class SearcheduserView extends StatelessWidget {
  const SearcheduserView({super.key, required this.userList});
  final List<UserModel> userList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  tileColor: Colors.grey[200],
                  dense: true,
                  visualDensity:
                      const VisualDensity(horizontal: 2, vertical: 0),
                  contentPadding: const EdgeInsets.all(8),
                  minLeadingWidth: 15,
                  horizontalTitleGap: 8,
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.profilePhoto),
                  ),
                  onTap: () {
                    Get.to(() => ProfileScreen(
                          uid: user.uid,
                          isFromSamePage: false,
                        ));
                  },
                  trailing: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black54,
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.name,
                        style: Get.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      giveSpace(height: 1),
                      Text(
                        user.bio,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Get.textTheme.bodySmall!
                            .copyWith(color: Colors.black45),
                      ),
                    ],
                  ));
            }),
        giveSpace(height: 4),
        const Divider(
          color: Colors.black12,
          height: 1,
          thickness: 2,
        ),
        giveSpace(height: 16)
      ],
    );
  }
}
