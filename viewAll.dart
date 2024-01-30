import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'indivisulattendii.dart';

class DisplayAttendanceScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purpleAccent),
        backgroundColor: Colors.cyanAccent,
        title: Text('View All',style: GoogleFonts.aladin(color: Colors.purpleAccent),),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Click an individual to see full Attendance',
            style: GoogleFonts.agdasima(color: Colors.orange),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No attendance records found.');
                }

                Set<String> uniqueNames = Set();

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var documentData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    String name = documentData['name'];

                    if (!uniqueNames.contains(name)) {
                      uniqueNames.add(name);

                      return Dismissible(
                        key: Key(name),
                        onDismissed: (direction) {
                          // Remove the item from the data source (Firestore) here
                          FirebaseFirestore.instance
                              .collection('users')
                              .where('name', isEqualTo: name)
                              .get()
                              .then((querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              doc.reference.delete();
                            });
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name dismissed'),
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text('Name:\n$name'),
                            subtitle: Text('Roll No: ${documentData['roll']}'),
                            onTap: () {
                              // Set valid DateTime values for startDate and endDate
                              DateTime startDate = DateTime(2000); // Choose a default start date
                              DateTime endDate = DateTime.now();  // Choose a default end date

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndividualAttendanceScreen(
                                    name: name,
                                    startDate: startDate,
                                    endDate: endDate,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
