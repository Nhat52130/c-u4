import 'package:ff123/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'CRUD LopHoc',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// class _HomePageState extends State<HomePage> {
//   // text fields' controllers
//   final TextEditingController _hoTenController = TextEditingController();
//   final TextEditingController _diaChiController = TextEditingController();
//   final TextEditingController _maGiangVienController = TextEditingController();
//   final TextEditingController _sdtController = TextEditingController();

//   final CollectionReference _giangvien =
//       FirebaseFirestore.instance.collection('giangvien');

//   // This function is triggered when the floatting button or one of the edit buttons is pressed
//   // Adding a product if no documentSnapshot is passed
//   // If documentSnapshot != null then update an existing product
//   Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
//     String action = 'create';
//     if (documentSnapshot != null) {
//       action = 'update';
//       _hoTenController.text = documentSnapshot['hoten'];
//       _diaChiController.text = documentSnapshot['diachi'];
//       _maGiangVienController.text = documentSnapshot['magiangvien'].toString();
//       _sdtController.text = documentSnapshot['sdt'].toString();
//     }

//     await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext ctx) {
//           return Padding(
//             padding: EdgeInsets.only(
//                 top: 20,
//                 left: 20,
//                 right: 20,
//                 // prevent the soft keyboard from covering text fields
//                 bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: _diaChiController,
//                   decoration: const InputDecoration(labelText: 'Dia chi:'),
//                 ),
//                 TextField(
//                   controller: _hoTenController,
//                   decoration: const InputDecoration(labelText: 'Ho ten:'),
//                 ),
//                 TextField(
//                   controller: _maGiangVienController,
//                   decoration:
//                       const InputDecoration(labelText: 'Ma giang vien:'),
//                 ),
//                 TextField(
//                   keyboardType:
//                       const TextInputType.numberWithOptions(decimal: true),
//                   controller: _sdtController,
//                   decoration: const InputDecoration(
//                     labelText: 'giang vien',
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                   child: Text(action == 'create' ? 'Create' : 'Update'),
//                   onPressed: () async {
//                     final String? hoten = _diaChiController.text;
//                     final String? magiangvien = _maGiangVienController.text;
//                     final String? diachi = _hoTenController.text;
//                     final double? sdt = double.tryParse(_sdtController.text);
//                     if (hoten != null &&
//                         magiangvien != null &&
//                         diachi != null &&
//                         sdt != null) {
//                       if (action == 'create') {
//                         // Persist a new product to Firestore
//                         await _giangvien.add({
//                           "MaLop": hoten,
//                           "TenLop": magiangvien,
//                           "MaGianVien": diachi,
//                           "SoLuong": sdt
//                         });
//                       }
//                       if (action == 'update') {
//                         await _giangvien.doc(documentSnapshot!.id).update({
//                           "MaLop": hoten,
//                           "TenLop": magiangvien,
//                           "MaGianVien": diachi,
//                           "SoLuong": sdt
//                         });
//                       }

//                       _diaChiController.text = '';
//                       _maGiangVienController.text = '';
//                       _hoTenController.text = '';
//                       _sdtController.text = '';

//                       Navigator.of(context).pop();
//                     }
//                   },
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   // Deleteing a product by id
//   Future<void> _deleteProduct(String lopHocId) async {
//     await _giangvien.doc(lopHocId).delete();

//     // Show a snackbar
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('You have successfully deleted a product')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('crud.com'),
//       ),
//       // Using StreamBuilder to display all products from Firestore in real-time
//       body: StreamBuilder(
//         stream: _giangvien.snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             return ListView.builder(
//               itemCount: streamSnapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 final DocumentSnapshot documentSnapshot =
//                     streamSnapshot.data!.docs[index];
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(documentSnapshot['hoten']),
//                     subtitle: Text(documentSnapshot['magiangvien'].toString()),
//                     trailing: SizedBox(
//                       width: 100,
//                       child: Row(
//                         children: [
//                           // Press this button to edit a single product
//                           IconButton(
//                               icon: const Icon(Icons.edit),
//                               onPressed: () =>
//                                   _createOrUpdate(documentSnapshot)),
//                           // This icon button is used to delete a single product
//                           IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () =>
//                                   _deleteProduct(documentSnapshot.id)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }

//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//       // Add new product
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _createOrUpdate(),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// ---------------

// import 'firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'json.dart';

// class FirebaseServices {
//   static Future<DocumentSnapshot> adminSignIn(id) async {
//     var res =
//         await FirebaseFirestore.instance.collection("admin").doc(id).get();
//     return res;
//   }
// }

// class monHoc extends StatefulWidget{
//   @override
//   // ignore: library_private_types_in_public_api
//   _monHocState createState() => _monHocState();
// }

class _HomePageState extends State<HomePage> {
// class _monHocState extends State<monHoc> {
  final _id = TextEditingController();
  final _maSinhVien = TextEditingController();

  final _ngaySinh = TextEditingController();

  final _gioiTinh = TextEditingController();

  final _queQuan = TextEditingController();
  var _output = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromARGB(255, 186, 248, 244),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('ID:'),
                  ),
                  Container(
                      width: 300,
                      child: TextField(
                        controller: _id,
                      )),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('Mã sinh viên:'),
                  ),
                  Container(
                      width: 300,
                      child: TextField(
                        controller: _maSinhVien,
                      )),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('Ngày sinh:'),
                  ),
                  Container(
                      width: 300,
                      child: TextField(
                        controller: _ngaySinh,
                      )),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('Giới tính:'),
                  ),
                  Container(
                      width: 300,
                      child: TextField(
                        controller: _gioiTinh,
                      )),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child: Text('Quê quán:'),
                  ),
                  Container(
                      width: 300,
                      child: TextField(
                        controller: _queQuan,
                      )),
                ],
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  CollectionReference collection =
                      FirebaseFirestore.instance.collection('SinhVien');
                  await collection.add({
                    "maSinhVien": _maSinhVien.text,
                    "ngaySinh": _ngaySinh.text,
                    "gioiTinh": _gioiTinh.text,
                    "queQuan": _queQuan.text
                  });
                },
                child: Text('Tạo'),
              ),
            ),
            Container(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      CollectionReference collection =
                          FirebaseFirestore.instance.collection('SinhVien');

                      await collection.doc(_id.text).update({
                        "maSinhVien": _maSinhVien.text,
                        "ngaySinh": _ngaySinh.text,
                        "gioiTinh": _gioiTinh.text,
                        "queQuan": _queQuan.text
                      });
                    },
                    child: Text('Sửa'),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      CollectionReference collection =
                          FirebaseFirestore.instance.collection('SinhVien');
                      collection.doc(_id.text).delete();
                    },
                    child: Text('Xóa'),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      CollectionReference collection =
                          FirebaseFirestore.instance.collection('SinhVien');
                      QuerySnapshot querySnapshot = await collection.get();
                      List<DocumentSnapshot> documents = querySnapshot.docs;
                      setState(() {
                        for (var doc in documents) {
                          _output = _output + doc.data().toString();
                        }
                      });
                    },
                    child: Text('In ra'),
                  ),
                  Text(_output),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
