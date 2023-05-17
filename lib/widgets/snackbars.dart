import 'package:flutter/material.dart';
import 'package:get/utils.dart';

void showSimpleSnackBar(
    {required BuildContext context,
    required String message,
    Color bgColor = Colors.blue,
    Color color = Colors.black,
    int duration = 3}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message, style: TextStyle(color: color)),
    backgroundColor: bgColor,
    duration: Duration(seconds: duration),
  ));
}

class SyncDataActionSnackBar extends SnackBar {
  final BuildContext context;
  final void Function()? onAccept;
  final void Function()? onDismiss;
  final void Function()? onClose;

  SyncDataActionSnackBar(
      {Key? key,
      required this.context,
      this.onAccept,
      this.onDismiss,
      this.onClose})
      : super(
            key: key,
            width: 400,
            padding: const EdgeInsets.all(0),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(minutes: 30),
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Stack(
              children: [
                Container(
                  height: 158,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1b1b1b),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("You're online!",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(
                        height: 11,
                      ),
                      const Text(
                        "Sync your current history data to the cloud to access it from other devices",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PopupActionButton(
                            text: "Dismiss",
                            type: ButttonType.secondary,
                            onPressed: () {
                              onDismiss?.call();
                              _closeSyncDataActionSnackBar(context, onClose);
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          PopupActionButton(
                            text: "Sync",
                            icon: Icons.cloud_sync,
                            onPressed: () {
                              onAccept?.call();
                              _closeSyncDataActionSnackBar(context, onClose);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton(
                        splashRadius: 25,
                        onPressed: () {
                          onDismiss?.call();
                          _closeSyncDataActionSnackBar(context, onClose);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ));
}

enum ButttonType { primary, secondary }

class PopupActionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final ButttonType type;
  final void Function() onPressed;

  const PopupActionButton({
    Key? key,
    required this.text,
    this.icon,
    this.type = ButttonType.primary,
    required this.onPressed,
  }) : super(key: key);

  Map<dynamic, Color> get colors {
    Color bgColor;
    Color textColor;

    if (type == ButttonType.primary) {
      bgColor = Colors.amber;
      textColor = Colors.black;
    } else {
      bgColor = const Color(0xFF1b1b1b);
      textColor = Colors.amber;
    }

    return {'bg': bgColor, 'text': textColor};
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
        avatar: icon != null
            ? Icon(
                icon,
                color: colors["text"],
              )
            : null,
        label: Text(text,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: colors["text"])),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        autofocus: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: type == ButttonType.primary
                ? BorderSide.none
                : const BorderSide(color: Colors.amber, width: 1)),
        backgroundColor: colors["bg"],
        onPressed: onPressed);
  }
}

void showSyncDataActionSnackBar(
    {required BuildContext context,
    void Function()? onAccept,
    void Function()? onDismiss,
    void Function()? onClose}) {
  ScaffoldMessenger.of(context).showSnackBar(SyncDataActionSnackBar(
      context: context,
      onAccept: onAccept,
      onDismiss: onDismiss,
      onClose: onClose));
}

void _closeSyncDataActionSnackBar(
    BuildContext context, void Function()? onClose) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  onClose?.call();
}
