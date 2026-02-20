import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/bottom_drawer.dart';
import 'package:watersec_mobileapp_front/ViewModel/notificationViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final DateFormat dformat = DateFormat('dd/MM/yyyy');

  final Set<String> _selectedIds = {};
  bool _selectionMode = false;

  int _visibleCount = 8;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<NotificationViewModel>().loadNotifications());
  }

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────
  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.every((p) => p.isEmpty)) return "?";
    // Take first letter of each word (up to 3 to keep it clean)
    return parts
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase())
        .take(3)
        .join();
  }

  Color _severityBorderColor(String type) {
    switch (type.toLowerCase()) {
      case 'critical':
        return red;
      case 'warning':
        return const Color(0xFFFFA000); // amber/orange
      default:
        return blue;
    }
  }

  bool _isRead(dynamic n) => n.readAt != null;

  void _enterSelection(String id) {
    setState(() {
      _selectionMode = true;
      _selectedIds.add(id);
    });
  }

  void _toggleSelect(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _selectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _exitSelection() {
    setState(() {
      _selectionMode = false;
      _selectedIds.clear();
    });
  }

  void _selectAll(List<dynamic> list) {
    setState(() {
      _selectionMode = true;
      _selectedIds
        ..clear()
        ..addAll(list.map((n) => n.id as String));
    });
  }

  // ─────────────────────────────────────────────
  // Popup details (matches your ORIGINAL card info)
  // ─────────────────────────────────────────────
  Future<void> _showDetailsDialog(dynamic n) async {
    final type = (n.data.type ?? '').toString();
    final device = (n.data.device ?? '').toString();
    final description = (n.data.description ?? '').toString();
    final message = (n.data.message ?? '').toString();
    final date = dformat.format(DateTime.parse(n.createdAt));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row: TYPE badge + DEVICE badge
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: type.toLowerCase() == "critical"
                        ? red
                        : const Color(0xFFFFA000),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type.toUpperCase(),
                    style: TextStyles.notifType(white),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: gray.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    device,
                    style: TextStyles.notifDevice(
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Title
            Text(
              description,
              style: TextStyles.notifTitle(
                Theme.of(context).colorScheme.secondary,
              ),
            ),

            const SizedBox(height: 10),

            // Message
            Text(
              message,
              style: TextStyles.notifdesc(
                Theme.of(context).colorScheme.secondary,
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                date,
                style: TextStyles.notifdate(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Selection actions in AppBar
  // ─────────────────────────────────────────────
  Future<void> _markSelectedAsRead() async {
    final vm = context.read<NotificationViewModel>();
    for (final id in _selectedIds) {
      await vm.markAsRead(id);
    }
    _exitSelection();
  }

  Future<void> _markSelectedAsUnread() async {
    // Not implemented in your ViewModel yet.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("markAsUnread not implemented yet")),
    );
  }

  Future<void> _deleteSelected() async {
    final vm = context.read<NotificationViewModel>();
    for (final id in _selectedIds) {
      await vm.deleteNotification(id);
    }
    _exitSelection();
  }

  // ─────────────────────────────────────────────
  // Single item dropdown menu (⋮)
  // ─────────────────────────────────────────────
  Future<void> _handleItemMenu(String action, dynamic n) async {
    final vm = context.read<NotificationViewModel>();

    if (action == 'read') {
      if (!_isRead(n)) await vm.markAsRead(n.id);
      return;
    }

    if (action == 'unread') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("markAsUnread not implemented yet")),
      );
      return;
    }

    if (action == 'delete') {
      await vm.deleteNotification(n.id);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();
    final fullList = vm.notifications;

    final items = fullList.take(_visibleCount).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      // ✅ AppBar changes based on selection mode
      appBar: _selectionMode
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: _exitSelection,
              ),
              title: Text(
                "${_selectedIds.length} selected",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: "Select all",
                  icon: const Icon(Icons.select_all, color: Colors.black),
                  onPressed: () => _selectAll(items),
                ),
                IconButton(
                  tooltip: "Mark as read",
                  icon: const Icon(Icons.mark_email_read_outlined,
                      color: Colors.black),
                  onPressed: _selectedIds.isEmpty ? null : _markSelectedAsRead,
                ),
                IconButton(
                  tooltip: "Mark as unread",
                  icon: const Icon(Icons.mark_email_unread_outlined,
                      color: Colors.black),
                  onPressed:
                      _selectedIds.isEmpty ? null : _markSelectedAsUnread,
                ),
                IconButton(
                  tooltip: "Delete",
                  icon: Icon(Icons.delete_outline, color: red),
                  onPressed: _selectedIds.isEmpty ? null : _deleteSelected,
                ),
                const SizedBox(width: 6),
              ],
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: MyAppBar(
                title: AppLocale.Notifications.getString(context),
              ),
            ),

      bottomNavigationBar: const MyBottomNav(currentIndex: 3),

      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await vm.loadNotifications();
                      setState(() {});
                    },
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final n = items[index];
                        final selected = _selectedIds.contains(n.id);
                        final read = _isRead(n);

                        final borderColor =
                            _severityBorderColor(n.data.type ?? '');
                        final initials = _initials(n.data.device ?? '');
                        final date =
                            dformat.format(DateTime.parse(n.createdAt));
                        final title = (n.data.description ?? '').toString();

                        return InkWell(
                          onTap: () async {
                            if (_selectionMode) {
                              _toggleSelect(n.id);
                              return;
                            }

                            if (!read) {
                              await context
                                  .read<NotificationViewModel>()
                                  .markAsRead(n.id);
                            }

                            await _showDetailsDialog(n);
                          },
                          onLongPress: () => _enterSelection(n.id),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            padding: const EdgeInsets.fromLTRB(10, 10, 6, 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? blue.withOpacity(0.10)
                                  : (read
                                      ? Theme.of(context).colorScheme.background
                                      : gray.withOpacity(0.20)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ✅ initials box (border colored by severity)
                                Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: borderColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // ✅ date next to initials + title below (ONLY)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Row: date only
                                      Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: read
                                              ? FontWeight.w500
                                              : FontWeight.w800,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ✅ dropdown menu (⋮)
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, size: 18),
                                  onSelected: (action) =>
                                      _handleItemMenu(action, n),
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      value: 'read',
                                      child: Row(
                                        children: const [
                                          Icon(Icons.mark_email_read_outlined,
                                              size: 18),
                                          SizedBox(width: 10),
                                          Text("Mark as read"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'unread',
                                      child: Row(
                                        children: const [
                                          Icon(Icons.mark_email_unread_outlined,
                                              size: 18),
                                          SizedBox(width: 10),
                                          Text("Mark as unread"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline,
                                              size: 18, color: red),
                                          SizedBox(width: 10),
                                          Text("Delete"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ✅ load more button
                if (_visibleCount < fullList.length)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: TextButton(
                      onPressed: () {
                        setState(() => _visibleCount += 8);
                      },
                      child: const Text("Load more"),
                    ),
                  ),
              ],
            ),
    );
  }
}
