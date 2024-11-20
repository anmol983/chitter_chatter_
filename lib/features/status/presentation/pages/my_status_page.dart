import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:whatsapp_clone_app/features/app/global/widgets/profile_widget.dart';
import 'package:whatsapp_clone_app/features/app/home/home_page.dart';
import 'package:whatsapp_clone_app/features/app/theme/style.dart';
import 'package:whatsapp_clone_app/features/status/domain/entities/status_entity.dart';
import 'package:whatsapp_clone_app/features/status/presentation/cubit/status/status_cubit.dart';
import 'package:whatsapp_clone_app/features/status/presentation/widgets/delete_status_update_alert.dart';

class MyStatusPage extends StatefulWidget {
  final StatusEntity status;

  const MyStatusPage({super.key, required this.status});

  @override
  State<MyStatusPage> createState() => _MyStatusPageState();
}

class _MyStatusPageState extends State<MyStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 34, 50),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 4, 20, 68),
        elevation: 4,
        title: const Text(
          "My Story",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.7)),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile picture with shadow and rounded border
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlueAccent.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32.5),
                    child: profileWidget(imageUrl: widget.status.imageUrl),
                  ),
                ),
                const SizedBox(width: 15),
                // Time display and popup menu for options
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status posted",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        GetTimeAgo.parse(
                          widget.status.createdAt!.toDate().subtract(
                              Duration(seconds: DateTime.now().second)),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                // Popup Menu
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert,
                      color: Colors.white.withOpacity(0.6)),
                  color: Colors.blueGrey.shade800,
                  iconSize: 28,
                  onSelected: (value) {},
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "Delete",
                      child: GestureDetector(
                        onTap: () {
                          deleteStatusUpdate(context, onTap: () {
                            Navigator.pop(context);
                            BlocProvider.of<StatusCubit>(context).deleteStatus(
                                status: StatusEntity(
                                    statusId: widget.status.statusId));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomePage(
                                  uid: widget.status.uid!,
                                  index: 1,
                                ),
                              ),
                            );
                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.redAccent),
                            const SizedBox(width: 8),
                            const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
