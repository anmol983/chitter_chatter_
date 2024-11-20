import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_story_view/flutter_story_view.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:whatsapp_clone_app/features/app/const/page_const.dart';
import 'package:whatsapp_clone_app/features/app/global/date/date_formats.dart';
import 'package:whatsapp_clone_app/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone_app/features/app/global/widgets/show_image_and_video_widget.dart';
import 'package:whatsapp_clone_app/features/app/home/home_page.dart';
import 'package:whatsapp_clone_app/features/app/theme/style.dart';
import 'package:whatsapp_clone_app/features/status/domain/entities/status_entity.dart';
import 'package:whatsapp_clone_app/features/status/domain/entities/status_image_entity.dart';
import 'package:path/path.dart' as path;
import 'package:whatsapp_clone_app/features/status/domain/usecases/get_my_status_future_usecase.dart';
import 'package:whatsapp_clone_app/features/status/presentation/cubit/get_my_status/get_my_status_cubit.dart';
import 'package:whatsapp_clone_app/features/status/presentation/cubit/status/status_cubit.dart';
import 'package:whatsapp_clone_app/features/status/presentation/widgets/status_dotted_borders_widget.dart';
import 'package:whatsapp_clone_app/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp_clone_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:whatsapp_clone_app/main_injection_container.dart' as di;
import 'package:whatsapp_clone_app/storage/storage_provider.dart';

class StatusPage extends StatefulWidget {
  final UserEntity currentUser;
  const StatusPage({super.key, required this.currentUser});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<StatusImageEntity> _stories = [];

  List<StoryItem> myStories = [];

  List<File>? _selectedMedia;
  List<String>? _mediaTypes; // To store the type of each selected file

  Future<void> selectMedia() async {
    setState(() {
      _selectedMedia = null;
      _mediaTypes = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();

        // Initialize the media types list
        _mediaTypes = List<String>.filled(_selectedMedia!.length, '');

        // Determine the type of each selected file
        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension =
              path.extension(_selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes![i] = 'video';
          }
        }

        setState(() {});
        print("mediaTypes = $_mediaTypes");
      } else {
        print("No file is selected.");
      }
    } catch (e) {
      print("Error while picking file: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<StatusCubit>(context).getStatuses(status: StatusEntity());

    BlocProvider.of<GetMyStatusCubit>(context)
        .getMyStatus(uid: widget.currentUser.uid!);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      di
          .sl<GetMyStatusFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty && myStatus.first.stories != null) {
          _fillMyStoriesList(myStatus.first);
        }
      });
    });
  }

  Future _fillMyStoriesList(StatusEntity status) async {
    if (status.stories != null) {
      _stories = status.stories!;
      for (StatusImageEntity story in status.stories!) {
        myStories.add(StoryItem(
            url: story.url!,
            type: StoryItemTypeExtension.fromString(story.type!),
            viewers: story.viewers!));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return BlocBuilder<StatusCubit, StatusState>(
      builder: (context, state) {
        if (state is StatusLoaded) {
          final statuses = state.statuses
              .where((element) => element.uid != widget.currentUser.uid)
              .toList();
          print("statuses loaded $statuses");

          return BlocBuilder<GetMyStatusCubit, GetMyStatusState>(
            builder: (context, state) {
              if (state is GetMyStatusLoaded) {
                print("loaded my status ${state.myStatus}");
                return _bodyWidget(statuses, widget.currentUser,
                    myStatus: state.myStatus);
              }

              return const Center(
                child: CircularProgressIndicator(
                  color: tabColor,
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: tabColor,
          ),
        );
      },
    );
    ;
  }

  _bodyWidget(List<StatusEntity> statuses, UserEntity currentUser,
      {StatusEntity? myStatus}) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Text(
                "Stories",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // User's Status with Elevated Card Style
              Card(
                color: Colors.blueGrey.shade800,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          myStatus != null
                              ? GestureDetector(
                                  onTap: () {
                                    _eitherShowOrUploadSheet(
                                        myStatus, currentUser);
                                  },
                                  child: Container(
                                    width: 65,
                                    height: 65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.lightBlueAccent
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: CustomPaint(
                                      painter: StatusDottedBordersWidget(
                                        isMe: true,
                                        numberOfStories:
                                            myStatus.stories!.length,
                                        spaceLength: 4,
                                        images: myStatus.stories!,
                                        uid: currentUser.uid,
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(3),
                                        width: 55,
                                        height: 55,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: profileWidget(
                                              imageUrl: myStatus.imageUrl),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32.5),
                                    color: Colors.blueGrey.shade700,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: profileWidget(
                                        imageUrl: currentUser.profileUrl),
                                  ),
                                ),
                          myStatus == null
                              ? Positioned(
                                  right: 8,
                                  bottom: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      _eitherShowOrUploadSheet(
                                          myStatus, currentUser);
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            width: 2,
                                            color: Colors.blueGrey.shade900),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "My Story",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                _eitherShowOrUploadSheet(myStatus, currentUser);
                              },
                              child: const Text(
                                "Tap to add your story",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.myStatusPage,
                            arguments: myStatus,
                          );
                        },
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Recent Posts Header with Accent Background
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.update,
                        color: Colors.lightBlueAccent, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      "Recent Posts",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Recent Statuses with Card Style
              ListView.builder(
                itemCount: statuses.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final status = statuses[index];
                  List<StoryItem> stories = status.stories!
                      .map((storyItem) => StoryItem(
                            url: storyItem.url!,
                            viewers: storyItem.viewers,
                            type: StoryItemTypeExtension.fromString(
                                storyItem.type!),
                          ))
                      .toList();

                  return Card(
                    color: Colors.blueGrey.shade800,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        _showStatusImageViewBottomModalSheet(
                          status: status,
                          stories: stories,
                        );
                      },
                      leading: SizedBox(
                        width: 55,
                        height: 55,
                        child: CustomPaint(
                          painter: StatusDottedBordersWidget(
                            isMe: false,
                            numberOfStories: status.stories!.length,
                            spaceLength: 4,
                            images: status.stories!,
                            uid: currentUser.uid,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            width: 55,
                            height: 55,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: profileWidget(imageUrl: status.imageUrl),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        status.username!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        formatDateTime(status.createdAt!.toDate()),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _showStatusImageViewBottomModalSheet(
      {StatusEntity? status, required List<StoryItem> stories}) async {
    print("storieas $stories");
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return FlutterStoryView(
          onComplete: () {
            Navigator.pop(context);
          },
          storyItems: stories,
          enableOnHoldHide: false,
          caption: "This is very beautiful photo",
          onPageChanged: (index) {
            BlocProvider.of<StatusCubit>(context).seenStatusUpdate(
                imageIndex: index,
                userId: widget.currentUser.uid!,
                statusId: status.statusId!);
          },
          createdAt: status!.createdAt!.toDate(),
        );
      },
    );
  }

  _uploadImageStatus(UserEntity currentUser) {
    StorageProviderRemoteDataSource.uploadStatuses(
            files: _selectedMedia!, onComplete: (onCompleteStatusUpload) {})
        .then((statusImageUrls) {
      for (var i = 0; i < statusImageUrls.length; i++) {
        _stories.add(StatusImageEntity(
          url: statusImageUrls[i],
          type: _mediaTypes![i],
          viewers: const [],
        ));
      }

      di
          .sl<GetMyStatusFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<StatusCubit>(context)
              .updateOnlyImageStatus(
                  status: StatusEntity(
                      statusId: myStatus.first.statusId, stories: _stories))
              .then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => HomePage(
                          uid: widget.currentUser.uid!,
                          index: 1,
                        )));
          });
        } else {
          BlocProvider.of<StatusCubit>(context)
              .createStatus(
            status: StatusEntity(
                caption: "",
                createdAt: Timestamp.now(),
                stories: _stories,
                username: currentUser.username,
                uid: currentUser.uid,
                profileUrl: currentUser.profileUrl,
                imageUrl: statusImageUrls[0],
                phoneNumber: currentUser.phoneNumber),
          )
              .then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => HomePage(
                          uid: widget.currentUser.uid!,
                          index: 1,
                        )));
          });
        }
      });
    });
  }

  void _eitherShowOrUploadSheet(
      StatusEntity? myStatus, UserEntity currentUser) {
    if (myStatus != null) {
      _showStatusImageViewBottomModalSheet(
          status: myStatus, stories: myStories);
    } else {
      selectMedia().then(
        (value) {
          if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return ShowMultiImageAndVideoPickedWidget(
                  selectedFiles: _selectedMedia!,
                  onTap: () {
                    _uploadImageStatus(currentUser);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      );
    }
  }
}
