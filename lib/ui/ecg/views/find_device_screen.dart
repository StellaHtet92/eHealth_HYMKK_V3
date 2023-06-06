import 'package:ehealth/routing/route_names.dart';
import 'package:ehealth/ui/ecg/add_ecg_page_two.dart';
import 'package:ehealth/ui/ecg/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () {
                            Navigator.pushNamed(context, getEcgResultsRoute, arguments: r.device);
                          }
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              child: const Icon(Icons.search),
              onPressed: () => FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4)),
            );
          }
        },
      ),
    );
  }
}
