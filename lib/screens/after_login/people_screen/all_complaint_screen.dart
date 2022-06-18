import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/models/Report.dart';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:complaints_app/screens/after_login/admin_screen/drawer_admin_widget.dart';
import 'package:complaints_app/screens/after_login/ministry_screen/drawer_ministry_widget.dart';
import 'package:complaints_app/screens/after_login/people_screen/read_complaint_screen.dart';
import 'package:complaints_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'drawer_user_widget.dart';

class AllComplaintScreen extends StatefulWidget {
  bool completedSelect = false;

  @override
  _AllComplaintScreenState createState() => _AllComplaintScreenState();
}

class _AllComplaintScreenState extends State<AllComplaintScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().designHeight(7).designWidth(4.15).init(context);
    return Scaffold(
        drawer: (AppPreferences().getUserData.levelUser == '1')
            ? DrawerAdminWidget()
            : (AppPreferences().getUserData.levelUser == '2')
                ? DrawerMinistryWidget()
                : DrawerPeopleWidget(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            'Order List',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.completedSelect = false;
                      setState(() {});
                    },
                    child: Container(
                      height: SizeConfig().scaleHeight(50),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(
                              width: (!widget.completedSelect) ? 1 : 0)),
                      child: Center(
                          child: Text(
                        'Under Review',
                        style: TextStyle(
                          color: Colors.white,
                            fontWeight: (!widget.completedSelect)
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.completedSelect = true;
                      setState(() {});
                    },
                    child: Container(
                      height: SizeConfig().scaleHeight(50),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(
                              width: (widget.completedSelect) ? 1 : 0)),
                      child: Center(
                          child: Text(
                        'Completed',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: (widget.completedSelect)
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
                child: streemFireBase(
              completedSelect: widget.completedSelect,
            )),
          ],
        )
        // SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       // Row(
        //
        //     ],
        //   ),
        // ),
        );
  }
}

class streemFireBase extends StatelessWidget {
  streemFireBase({required this.completedSelect});

  late bool completedSelect;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FbFireStoreController().read(
          nameCollection: 'Reports', orderBy: 'timeReport', descending: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<QueryDocumentSnapshot> data = snapshot.data!.docs;
          List<Report> allDataReport = listData(data: data);
          if (allDataReport.length == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, size: 85, color: Colors.grey.shade500),
                  Text(
                    'No Orders',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            );
          } else {
            return ListView.separated(
              itemBuilder: (context, index) {
                String path = allDataReport[index].path;
                String ministry = allDataReport[index].ministryName;
                String date = allDataReport[index].date;
                String day = allDataReport[index].day;
                return ListTile(
                  leading: IconStateComplaint(
                      isDoneFromAdmin: allDataReport[index].isDoneFromAdmin,
                      isDoneFromMinistry:
                          allDataReport[index].isDoneFromMinistry,
                      isBackToMinistry: allDataReport[index].isBackToMinistry),
                  title: Text(
                    'Report sent to $ministry',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  subtitle: Text('Send in $day - $date'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadComplaintScreen(
                          report: allDataReport[index],
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey.shade500);
              },
              itemCount: allDataReport.length,
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, size: 85, color: Colors.grey.shade500),
                Text(
                  'No reports',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  List<Report> listData({required List<QueryDocumentSnapshot> data}) {
    List<Report> dataReport = [];
    dataReport.clear();
    for (int i = 0; i < data.length; i++) {
      if (completedSelect == true && data[i].get('isDoneFromAdmin')) {
        if (AppPreferences().getUserData.levelUser == '1') {
          Report p = Report();
          p.path = data[i].id;
          p.problemText = data[i].get('problemText');
          p.address = data[i].get('address');
          p.senderName = data[i].get('senderName');
          p.senderEmail = data[i].get('senderEmail');
          p.senderMobile = data[i].get('senderMobile');
          p.ministryName = data[i].get('ministryName');
          p.ministryReplay = data[i].get('ministryReplay');
          p.adminReplay = data[i].get('adminReplay');
          p.isDoneFromAdmin = data[i].get('isDoneFromAdmin');
          p.isDoneFromMinistry = data[i].get('isDoneFromMinistry');
          p.isBackToMinistry = data[i].get('isBackToMinistry');
          p.countImageUpload = data[i].get('countImageUpload');
          p.urlImage1 = data[i].get('urlImage1');
          p.urlImage2 = data[i].get('urlImage2');
          p.urlImage3 = data[i].get('urlImage3');
          p.urlImage4 = data[i].get('urlImage4');
          p.urlImage5 = data[i].get('urlImage5');
          p.urlImage6 = data[i].get('urlImage6');
          p.urlImage7 = data[i].get('urlImage7');
          p.urlImage8 = data[i].get('urlImage8');
          p.urlImage9 = data[i].get('urlImage9');
          p.urlImage10 = data[i].get('urlImage10');
          p.day = data[i].get('day');
          p.date = data[i].get('date');
          p.timeReport = data[i].get('timeReport').toDate();

          dataReport.add(p);
        } else if (AppPreferences().getUserData.levelUser == '2' &&
            data[i].get('ministryName') == AppPreferences().getUserData.name) {
          Report p = Report();
          p.path = data[i].id;
          p.problemText = data[i].get('problemText');
          p.address = data[i].get('address');
          p.senderName = data[i].get('senderName');
          p.senderEmail = data[i].get('senderEmail');
          p.senderMobile = data[i].get('senderMobile');
          p.ministryName = data[i].get('ministryName');
          p.ministryReplay = data[i].get('ministryReplay');
          p.adminReplay = data[i].get('adminReplay');
          p.isDoneFromAdmin = data[i].get('isDoneFromAdmin');
          p.isDoneFromMinistry = data[i].get('isDoneFromMinistry');
          p.isBackToMinistry = data[i].get('isBackToMinistry');
          p.countImageUpload = data[i].get('countImageUpload');
          p.urlImage1 = data[i].get('urlImage1');
          p.urlImage2 = data[i].get('urlImage2');
          p.urlImage3 = data[i].get('urlImage3');
          p.urlImage4 = data[i].get('urlImage4');
          p.urlImage5 = data[i].get('urlImage5');
          p.urlImage6 = data[i].get('urlImage6');
          p.urlImage7 = data[i].get('urlImage7');
          p.urlImage8 = data[i].get('urlImage8');
          p.urlImage9 = data[i].get('urlImage9');
          p.urlImage10 = data[i].get('urlImage10');
          p.day = data[i].get('day');
          p.date = data[i].get('date');
          p.timeReport = data[i].get('timeReport').toDate();

          dataReport.add(p);
        } else if (AppPreferences().getUserData.levelUser == '3' &&
            data[i].get('senderEmail') == AppPreferences().getUserData.email) {
          Report p = Report();
          p.path = data[i].id;
          p.problemText = data[i].get('problemText');
          p.address = data[i].get('address');
          p.senderName = data[i].get('senderName');
          p.senderEmail = data[i].get('senderEmail');
          p.senderMobile = data[i].get('senderMobile');
          p.ministryName = data[i].get('ministryName');
          p.ministryReplay = data[i].get('ministryReplay');
          p.adminReplay = data[i].get('adminReplay');
          p.isDoneFromAdmin = data[i].get('isDoneFromAdmin');
          p.isDoneFromMinistry = data[i].get('isDoneFromMinistry');
          p.isBackToMinistry = data[i].get('isBackToMinistry');
          p.countImageUpload = data[i].get('countImageUpload');
          p.urlImage1 = data[i].get('urlImage1');
          p.urlImage2 = data[i].get('urlImage2');
          p.urlImage3 = data[i].get('urlImage3');
          p.urlImage4 = data[i].get('urlImage4');
          p.urlImage5 = data[i].get('urlImage5');
          p.urlImage6 = data[i].get('urlImage6');
          p.urlImage7 = data[i].get('urlImage7');
          p.urlImage8 = data[i].get('urlImage8');
          p.urlImage9 = data[i].get('urlImage9');
          p.urlImage10 = data[i].get('urlImage10');
          p.day = data[i].get('day');
          p.date = data[i].get('date');
          p.timeReport = data[i].get('timeReport').toDate();

          dataReport.add(p);
        }
      } else if (completedSelect == false && !data[i].get('isDoneFromAdmin')) {
        if (AppPreferences().getUserData.levelUser == '1') {
          Report p = Report();
          p.path = data[i].id;
          p.problemText = data[i].get('problemText');
          p.address = data[i].get('address');
          p.senderName = data[i].get('senderName');
          p.senderEmail = data[i].get('senderEmail');
          p.senderMobile = data[i].get('senderMobile');
          p.ministryName = data[i].get('ministryName');
          p.ministryReplay = data[i].get('ministryReplay');
          p.adminReplay = data[i].get('adminReplay');
          p.isDoneFromAdmin = data[i].get('isDoneFromAdmin');
          p.isDoneFromMinistry = data[i].get('isDoneFromMinistry');
          p.isBackToMinistry = data[i].get('isBackToMinistry');
          p.countImageUpload = data[i].get('countImageUpload');
          p.urlImage1 = data[i].get('urlImage1');
          p.urlImage2 = data[i].get('urlImage2');
          p.urlImage3 = data[i].get('urlImage3');
          p.urlImage4 = data[i].get('urlImage4');
          p.urlImage5 = data[i].get('urlImage5');
          p.urlImage6 = data[i].get('urlImage6');
          p.urlImage7 = data[i].get('urlImage7');
          p.urlImage8 = data[i].get('urlImage8');
          p.urlImage9 = data[i].get('urlImage9');
          p.urlImage10 = data[i].get('urlImage10');
          p.day = data[i].get('day');
          p.date = data[i].get('date');
          p.timeReport = data[i].get('timeReport').toDate();

          dataReport.add(p);
        } else if (AppPreferences().getUserData.levelUser == '2' &&
            data[i].get('ministryName') == AppPreferences().getUserData.name) {
          Report p = Report();
          p.path = data[i].id;
          p.problemText = data[i].get('problemText');
          p.address = data[i].get('address');
          p.senderName = data[i].get('senderName');
          p.senderEmail = data[i].get('senderEmail');
          p.senderMobile = data[i].get('senderMobile');
          p.ministryName = data[i].get('ministryName');
          p.ministryReplay = data[i].get('ministryReplay');
          p.adminReplay = data[i].get('adminReplay');
          p.isDoneFromAdmin = data[i].get('isDoneFromAdmin');
          p.isDoneFromMinistry = data[i].get('isDoneFromMinistry');
          p.isBackToMinistry = data[i].get('isBackToMinistry');
          p.countImageUpload = data[i].get('countImageUpload');
          p.urlImage1 = data[i].get('urlImage1');
          p.urlImage2 = data[i].get('urlImage2');
          p.urlImage3 = data[i].get('urlImage3');
          p.urlImage4 = data[i].get('urlImage4');
          p.urlImage5 = data[i].get('urlImage5');
          p.urlImage6 = data[i].get('urlImage6');
          p.urlImage7 = data[i].get('urlImage7');
          p.urlImage8 = data[i].get('urlImage8');
          p.urlImage9 = data[i].get('urlImage9');
          p.urlImage10 = data[i].get('urlImage10');
          p.day = data[i].get('day');
          p.date = data[i].get('date');
          p.timeReport = data[i].get('timeReport').toDate();

          dataReport.add(p);
        } else if (AppPreferences().getUserData.levelUser == '3' &&
            data[i].get('senderEmail') == AppPreferences().getUserData.email) {
          Report p = Report();
          p.path = data[i].id;
          p.problemText = data[i].get('problemText');
          p.address = data[i].get('address');
          p.senderName = data[i].get('senderName');
          p.senderEmail = data[i].get('senderEmail');
          p.senderMobile = data[i].get('senderMobile');
          p.ministryName = data[i].get('ministryName');
          p.ministryReplay = data[i].get('ministryReplay');
          p.adminReplay = data[i].get('adminReplay');
          p.isDoneFromAdmin = data[i].get('isDoneFromAdmin');
          p.isDoneFromMinistry = data[i].get('isDoneFromMinistry');
          p.isBackToMinistry = data[i].get('isBackToMinistry');
          p.countImageUpload = data[i].get('countImageUpload');
          p.urlImage1 = data[i].get('urlImage1');
          p.urlImage2 = data[i].get('urlImage2');
          p.urlImage3 = data[i].get('urlImage3');
          p.urlImage4 = data[i].get('urlImage4');
          p.urlImage5 = data[i].get('urlImage5');
          p.urlImage6 = data[i].get('urlImage6');
          p.urlImage7 = data[i].get('urlImage7');
          p.urlImage8 = data[i].get('urlImage8');
          p.urlImage9 = data[i].get('urlImage9');
          p.urlImage10 = data[i].get('urlImage10');
          p.day = data[i].get('day');
          p.date = data[i].get('date');
          p.timeReport = data[i].get('timeReport').toDate();

          dataReport.add(p);
        }
      }
    }
    print(dataReport.length);
    return dataReport;
  }

  Icon IconStateComplaint(
      {required bool isDoneFromAdmin,
      required bool isDoneFromMinistry,
      required bool isBackToMinistry}) {
    if (isDoneFromAdmin) {
      return Icon(Icons.assignment_turned_in);
    } else {
      if (AppPreferences().getUserData.levelUser == '1' && isDoneFromMinistry) {
        return Icon(Icons.assignment_turned_in_outlined);
      } else if (AppPreferences().getUserData.levelUser == '2' &&
          isDoneFromMinistry) {
        return Icon(Icons.threesixty_rounded);
      }
      return Icon(Icons.access_time_outlined);
    }
  }
}
