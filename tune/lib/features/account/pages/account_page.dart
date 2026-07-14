import 'package:flutter/material.dart';


/// Account menu — profile summary, upgrade prompt, and settings entry,
/// matching the sheet YouTube Music shows from the profile avatar.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(radius: 28, child: Icon(Icons.person_rounded)),
            title: Text('Guest'),
            subtitle: Text('Not signed in'),
          ),
         
          const Divider(),
         
          
          ListTile(
            leading: const Icon(Icons.help_outline_rounded),
            title: const Text('Help & feedback'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
