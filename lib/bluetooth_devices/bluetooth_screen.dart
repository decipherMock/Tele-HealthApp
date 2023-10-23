import 'package:flutter/material.dart';

import '../flutterBlue/bluePage/blue_screen.dart';

class ConnectDevicesScreen extends StatelessWidget {
  const ConnectDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Text('Connect Devices'),
      ),
      body: ListView(
        children: [
         
            //Use this button to connect to the Devices screen and perform search, add and retrive data from devices
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScrean()));
                },
                child: const Text('Bluetooth Connect')),

                SizedBox(height: 20,),

               Text(
              'Connected Devices List',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            //! list of devices connected with their readings should be here 



            ///
        ],
      ),
    );
  }
}