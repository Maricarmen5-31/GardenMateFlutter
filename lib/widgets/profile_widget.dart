import 'package:flutter/material.dart';
import 'package:garden_mate/utils/constants.dart';

class ProfileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isLoading;

  const ProfileWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null && !isLoading ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Constants.blackColor.withOpacity(.5),
                  size: 24,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Constants.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (onTap != null)
              isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Icon(Icons.logout_outlined),
          ],
        ),
      ),
    );
  }
}
