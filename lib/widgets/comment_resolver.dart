import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shorts_clone/common.dart';
import 'package:shorts_clone/controllers/comment_controller.dart';
import 'package:shorts_clone/models/coment_model.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentResolver extends StatelessWidget {
  CommentResolver({super.key});
  final CommentController commentController = Get.find<CommentController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
        itemCount: commentController.comments.length,
        itemBuilder: (context, index) {
          CommentModel commentModel = commentController.comments[index];
          return Column(
            children: [
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 2, vertical: 0),
                contentPadding: const EdgeInsets.all(8),
                minLeadingWidth: 15,
                horizontalTitleGap: 8,
                leading: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(commentModel.profilePhoto),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "@${commentModel.username} . ${tago.format(commentModel.date.toDate())}"),
                    giveSpace(height: 4),
                    Text(commentModel.comment),
                    giveSpace(height: 8)
                  ],
                ),
                subtitle: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              // Like the comment...
                              commentController.likeComment(commentModel.id);
                            },
                            child:Icon(
                              Icons.thumb_up_sharp,
                              size: 15,
                              color: commentModel.likes.contains(firebaseAuth.currentUser!.uid)? Colors.red: Colors.black45,
                            )),
                        giveSpace(width: 4),
                        Text(commentModel.likes.length.toString())
                      ],
                    ),
                    giveSpace(width: 32),
                    InkWell(
                        onTap: () {
                          // dislike the comment...
                        },
                        child: const Icon(
                          Icons.thumb_down_sharp,
                          size: 15,
                        )),
                    giveSpace(width: 32),
                    InkWell(
                        onTap: () {
                          // comment on  the comment...
                        },
                        child: const Icon(
                          Icons.comment,
                          size: 15,
                        )),
                    giveSpace(width: 16),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black38,
                height: 1,
              )
            ],
          );
        }));
  }
}
