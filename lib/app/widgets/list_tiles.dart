import 'package:flutter/material.dart';
import 'package:lurkur/app/blocs/theme_cubit.dart';

class BodyListTile extends StatelessWidget {
  const BodyListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitles,
    this.body,
    this.contentAlignment,
    this.onPress,
    this.onLongPress,
  });

  final Widget? leading;
  final Widget? title;
  final List<Widget>? subtitles;
  final Widget? body;

  final CrossAxisAlignment? contentAlignment;

  final void Function()? onPress, onLongPress;

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    final title = this.title;
    final subtitles = this.subtitles ?? [];
    final body = this.body;
    return InkWell(
      onTap: onPress,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeCubit.medium1Padding,
          vertical: ThemeCubit.medium1Padding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: contentAlignment ?? CrossAxisAlignment.center,
              children: [
                if (leading != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      right: ThemeCubit.medium1Padding,
                    ),
                    child: leading,
                  ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) title,
                      for (final subtitle in subtitles) subtitle,
                    ],
                  ),
                ),
              ],
            ),
            if (body != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: ThemeCubit.medium1Padding,
                ),
                child: body,
              ),
          ],
        ),
      ),
    );
  }
}
