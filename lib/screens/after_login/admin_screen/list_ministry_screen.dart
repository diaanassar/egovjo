import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints_app/firebase/fb_firestore.dart';
import 'package:complaints_app/preferences/app_preferences.dart';
import 'package:complaints_app/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditMinistryListScreen extends StatefulWidget {
  @override
  _EditMinistryListScreenState createState() => _EditMinistryListScreenState();
}

class _EditMinistryListScreenState extends State<EditMinistryListScreen>
    with Helpers {
  List<Offset> pointList = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              int countBack = 0;
              Navigator.of(context).popUntil((_) => countBack++ >= 2);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          'List of Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FbFireStoreController().read(
                    nameCollection: 'users',
                    orderBy: 'levelUser',
                    descending: false),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                    return Visibility(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Visibility(
                            visible: data[index].get('levelUser') == '2',
                            child: ListTile(
                              leading: Icon(
                                Icons.account_circle_sharp,
                                size: 24,
                                color: Colors.black,
                              ),
                              title: Text(
                                '${data[index].get('name')} ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('${data[index].get('mobile')}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      addInFireStore(
                                          name: '${data[index].get('name')}',
                                          add: true);
                                      // name: 'name:${data[index].get('name')},path:${data[index].id}', add: true);
                                    },
                                    icon: Icon(
                                      Icons.verified_user,
                                      color: Colors.green,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      addInFireStore(
                                          name: '${data[index].get('name')}',
                                          add: false);
                                      // name: 'name:${data[index].get('name')},path:${data[index].id}', add: false);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Visibility(
                              visible: data[index].get('levelUser') == '2',
                              child: Divider(
                                height: 1,
                              ));
                        },
                        itemCount: data.length,
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning,
                              size: 85, color: Colors.grey.shade500),
                          Text(
                            'NO Ministry',
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
              ),
            ),
          ),

          // Flexible(
          //   flex: 2,
          //   fit: FlexFit.loose,
          //   child: ListView.builder(
          //     itemBuilder: (context, index) {
          //       List<String> data = AppPreferences().getArrayMinistry;
          //       return Text((data[index]));
          //     },
          //     itemCount: AppPreferences().getArrayMinistry.length,
          //
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> addInFireStore({required String name, required bool add}) async {
    if (add) {
      List<dynamic> addEmployee = <dynamic>[name];
      bool state = await FbFireStoreController().updateArray(
          nameDoc: 'ministryList', nameArray: 'Ministry', data: addEmployee);

      if (state) {
        showSnackBar(context: context, content: 'Added successfully');
      } else {
        showSnackBar(context: context, content: '', error: true);
      }
    } else {
      List<dynamic> deleteEmployee = <dynamic>[name];
      bool delete = await FbFireStoreController().deleteFromArray(
          nameDoc: 'ministryList', nameArray: 'Ministry', data: deleteEmployee);
      if (delete) {
        showSnackBar(context: context, content: 'Deleted successfully');
        // setState(() {});
      } else {
        showSnackBar(
            context: context,
            content: 'There was a problem while deleting',
            error: true);
      }
    }
  }
}
