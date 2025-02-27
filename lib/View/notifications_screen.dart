import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/ViewModel/notificationViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<bool> _expandedStates =
      []; // List to track expanded state for each notification

  @override
  void initState() {
    super.initState();
    // Fetch notifications when the screen is initialized
    Future.microtask(() =>
        Provider.of<NotificationViewModel>(context, listen: false)
            .loadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    final notificationViewModel = Provider.of<NotificationViewModel>(context);
    final String _page = AppLocale.Notifications.getString(context);
    final DateFormat dformat = DateFormat('dd/MM/yyyy');

    // Initialize the expanded state for each notification (to track whether each notification is expanded or not)
    if (_expandedStates.length != notificationViewModel.notifications.length) {
      _expandedStates =
          List.filled(notificationViewModel.notifications.length, false);
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: MyDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MyAppBar(page: _page),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await notificationViewModel.loadNotifications();
            setState(() {}); // Refresh the UI after loading
          },
          child: notificationViewModel.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                ) // Show loading indicator while fetching data
              : ListView.builder(
                  itemCount: notificationViewModel.notifications.length,
                  itemBuilder: (context, index) {
                    final notification =
                        notificationViewModel.notifications[index];
                    final bool isRead = notification.readAt != null;
                    final bool isExpanded = _expandedStates[index];

                    return GestureDetector(
                      onTap: () async {
                        if (!isRead) {
                          await Provider.of<NotificationViewModel>(context,
                                  listen: false)
                              .markAsRead(notification.id);
                        }
                        setState(() {
                          _expandedStates[index] = !_expandedStates[index];
                        });

                        // If expanding and notification is not yet read, mark it as read
                        /* if (!isRead && !_expandedStates[index]) {
                          await Provider.of<NotificationViewModel>(context,
                                  listen: false)
                              .markAsRead(notification.id);
                          setState(
                              () {}); // Re-render to change background color immediately
                        }*/
                      },
                      child: Slidable(
                        key: Key(notification.id),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                await notificationViewModel
                                    .deleteNotification(notification.id);
                                setState(() {}); // Refresh UI after deleting
                              },
                              backgroundColor: red,
                              foregroundColor: white,
                              icon: Icons.delete,
                              label: AppLocale.Delete.getString(context),
                            ),
                          ],
                        ),
                        child: Card(
                          color: isRead
                              ? Theme.of(context).colorScheme.background
                              : gray.withOpacity(
                                  0.4), // Gray background if unread
                          elevation: 2, // Adds some elevation to the card
                          margin: const EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 16.0), // Adds space between cards
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row to display the type and device
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            notification.data.type == "critical"
                                                ? red
                                                : blue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                          notification.data.type.toUpperCase(),
                                          style: TextStyles.notifType(
                                            white,
                                          )),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: gray.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(notification.data.device,
                                          style: TextStyles.notifDevice(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(notification.data.description,
                                    style: TextStyles.notifTitle(
                                      Theme.of(context).colorScheme.secondary,
                                    )),
                                SizedBox(height: 8),
                                // Show description and message only if expanded or notification is read
                                if (isRead || isExpanded) ...[
                                  Text(notification.data.message,
                                      style: TextStyles.notifdesc(
                                        Theme.of(context).colorScheme.secondary,
                                      )),
                                  SizedBox(height: 8),
                                ],

                                // Creation date, always visible
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                      dformat.format(DateTime.parse(
                                          notification.createdAt)),
                                      style: TextStyles.notifdate(
                                        Theme.of(context).colorScheme.secondary,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
