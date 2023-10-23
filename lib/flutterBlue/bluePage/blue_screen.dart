import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:sensordevices/flutterBlue/blue_controller.dart';

class SearchScrean extends StatelessWidget {
  const SearchScrean({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Search'),
      ),
      body: GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(children: [

              Container(
                height: 180,
                width: double.infinity,
                color: Colors.black,
                child:const Text('Blue Connect'),
              ),
              const SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                  child: Text('Scan'),
                   onPressed:()=> controller.scanDevice()),
              ),
              const SizedBox(height: 17,),
              StreamBuilder<List<ScanResult>>(
                stream: controller.scanResults, 
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                         shrinkWrap: true, 
                         itemCount: snapshot.data!.length,
                         itemBuilder: (context, index) { 
                          final data = snapshot.data![index];
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                 title: Text(data.device.name),
                                 subtitle: Text(data.device.id.id),
                                 trailing: Text(data.rssi.toString()),
                              ),
                            );
                          },
                    
                    );
                    }  else {
                    return const Center(child: Text('no devices found'),);
                  }
                  }
                
              )
            ]),
            );
        }
      )
    );
  }
}