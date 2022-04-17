import 'dart:convert';

import 'package:built_value/standard_json_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hider/screens/login/login_screen.dart';
import 'package:hider/services/authentication_model.dart';
import 'package:hider/services/item.dart';
import 'package:hider/services/serializers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              AuthenticationModel.instance.logout();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                  (route) => false);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(AuthenticationModel.instance.username)
            .collection('items')
            .snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          final theme = Theme.of(context);
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            print(snapshot.data!);
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index].data();
                final standardSerializers = (serializers.toBuilder()
                      ..addPlugin(StandardJsonPlugin()))
                    .build();
                final item =
                    standardSerializers.deserializeWith(Item.serializer, doc)!;
                return ListTile(
                  title: Text(item.title),
                  onTap: () {},
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const p = 'password';
          final bytes = utf8.encode(p);
          final newBytes = sha256.convert(bytes).bytes;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
