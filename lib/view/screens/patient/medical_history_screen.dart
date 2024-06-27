import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Medical History', style: TextStyle(
              color: Colors.black
          ),
          ),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('patients')
              .doc(FirebaseAuth.instance.currentUser?.uid).collection('patients_history').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
            }else if( snapshot.hasData){

              if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('History Is Empty'));
              } else {
                return snapshot.data==null?const Center(child: Text("History is empty")): ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    return HistoryComponent(
                      data: data,
                    );
                  }).toList(),
                );
              }

            }

            return const Center(child: Text('Something went wrong'));



          },
        ));

  }
}



// class HistoryComponent extends StatelessWidget {
//   final Map<String, dynamic> data;
//   const HistoryComponent({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }





class HistoryComponent extends StatelessWidget {
  final Map<String, dynamic> data;
  const HistoryComponent({super.key, required this.data});

  String _getEmoji(double accuracy) {
    if (accuracy >= 0.85) return '😊'; // Happy
    if (accuracy >= 0.65) return '🙂'; // Slightly happy
    if (accuracy >= 0.45) return '😐'; // Neutral
    if (accuracy >= 0.25) return '😟'; // Slightly sad
    return '😢'; // Sad
  }

  @override
  Widget build(BuildContext context) {
    final prediction = data['Prediction'];
    final accuracy = data['Accuracy'] as double;
    final emoji = _getEmoji(accuracy);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prediction Result',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    'Prediction: ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    prediction,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    'Accuracy: ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${(accuracy * 100).toStringAsFixed(2)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}