import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class NavItem {
  final String iconName;
  final String labelKey;

  NavItem({required this.iconName, required this.labelKey});

  factory NavItem.fromJson(Map<String, dynamic> json) => NavItem(
    iconName: json['icon'] as String,
    labelKey: json['label_key'] as String,
  );
}

class BottomNavBar extends StatefulWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late Future<List<NavItem>> _itemsFuture;

  static const _iconMap = {
    'home': Icons.home,
    'about': Icons.info,
    'contact': Icons.call,
  };

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadNavItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.locale; // отслеживаем смену языка и перерисовываем футер
  }

  Future<List<NavItem>> _loadNavItems() async {
    final raw = await rootBundle.loadString('assets/config/nav_items.json');
    final list = json.decode(raw) as List<dynamic>;
    return list.map((e) => NavItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return FutureBuilder<List<NavItem>>(
      future: _itemsFuture,
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return SizedBox(height: 72 + bottomInset);
        }

        final items = snap.data!;
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF001730),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              SizedBox(
                height: 72,
                child: Row(
                  children: items.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    final isActive = idx == widget.activeIndex;
                    final icon = _iconMap[item.iconName] ?? Icons.help_outline;

                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => widget.onTap(idx),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isActive ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    icon,
                                    size: 20,
                                    color: isActive ? const Color(0xFF001730) : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    item.labelKey.tr(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: bottomInset),
            ],
          ),
        );
      },
    );
  }
}