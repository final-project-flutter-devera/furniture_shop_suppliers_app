import 'package:flutter/material.dart';
import 'package:furniture_shop/Constants/Colors.dart';
import 'package:google_fonts/google_fonts.dart';

//Proposal
//actual notification will have label New or none
//advertisement will have label HOT!

class NotificationCard extends StatefulWidget {
  final bool hasImage;
  final bool isAd;
  final bool isViewed;
  const NotificationCard({
    super.key,
    required this.hasImage,
    required this.isAd,
    required this.isViewed,
  });

  @override
  State<StatefulWidget> createState() => _NotificationCardState();
}

//Card has two states:
//white color `isViewed = true`
//grey color when `isViewed = false`
//This state will be updated locally controlled by widget, value will be updated to firebase later
class _NotificationCardState extends State<NotificationCard> {
  late bool hasImage;
  late bool isAd;
  late bool isViewed;
  @override
  void initState() {
    hasImage = widget.hasImage;
    isAd = widget.isAd;
    isViewed = widget.isViewed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          isViewed = true;
        });
        showModalBottomSheet(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            context: context,
            builder: (BuildContext context) => Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification title',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              'Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description ',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 12,
                                color: AppColor.grey,
                              ),
                            ),
                          ),
                        )
                      ]),
                ));
      },
      style: ButtonStyle(
        padding:
            MaterialStateProperty.all(EdgeInsets.zero), // Set padding to zero
      ),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            color: isViewed ? AppColor.white : AppColor.blur_grey,
          ),
          width: double.infinity,
          padding: const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
          child: SizedBox(
            height: 70,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  !hasImage
                      ? const SizedBox(
                          width: 0,
                          height: 0,
                        )
                      : Container(
                          padding: const EdgeInsets.only(right: 10),
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/Images/Images/minimal_stand.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification title',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 5)),
                        LimitedBox(
                          maxHeight: 75,
                          child: Text(
                            'Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description Description ',
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              color: AppColor.grey,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
        Positioned(
            right: 20,
            bottom: 5,
            child: isViewed
                ? const Text('')
                : isAd
                    ? Text(
                        "HOT!",
                        style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColor.canceled,
                            shadows: [
                              Shadow(
                                color: isViewed
                                    ? AppColor.white
                                    : AppColor.blur_grey,
                                blurRadius: 5,
                              )
                            ]),
                      )
                    : Text('New',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColor.success,
                            shadows: [
                              Shadow(
                                color: isViewed
                                    ? AppColor.white
                                    : AppColor.blur_grey,
                                blurRadius: 5,
                              ),
                            ]))),
        Divider(
          height: 0,
          thickness: 1,
          indent: 20,
          endIndent: 20,
          color: isViewed ? AppColor.blur_grey : AppColor.white,
        )
      ]),
    );
  }
}
