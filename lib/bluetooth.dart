import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:accident_detection/widgets.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return const FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  void discoverServices(BluetoothDevice device) async {
    BluetoothCharacteristic characteristic;
    print("Discovering services------------------------------------- ");
    // print("Sleeping");
    // sleep(const Duration(seconds: 10));
    List<BluetoothService> servs = await device.discoverServices();
    servs.forEach(
      (service) {
        if (service.uuid.toString() == "4fafc201-1fb5-459e-8fcc-c5c9c331914b") {
          // Replace XXXX with the UUID of the service
          service.characteristics.forEach(
            (c) {
              if (c.uuid.toString() == "beb5483e-36e1-4688-b7f5-ea07361b26a8") {
                // Replace YYYY with the UUID of the characteristic
                print("!!!!!!!!!!Characteristic is matched");
                characteristic = c;
                subscribeToCharacteristic(characteristic);
              }
            },
          );
        }
      },
    );
    // print('Service not found');
  }

  // Subscribe to the characteristic to receive notifications
  void subscribeToCharacteristic(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);
    characteristic.value.listen(
      (value) async {
        // Handle the received message
        String message = String.fromCharCodes(value);
        print("message is : $message");
        if (message == 'accident') {
          // sleep(const Duration(seconds: 5));
          await characteristic.write(utf8.encode('Response'));
          print('!!!!!!!!!!Response sent');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBlue.instance
            .startScan(timeout: const Duration(seconds: 10)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (d) => ListTile(
                          title: Text(d.name),
                          subtitle: Text(d.id.toString()),
                          trailing: StreamBuilder<BluetoothDeviceState>(
                            stream: d.state,
                            initialData: BluetoothDeviceState.disconnected,
                            builder: (c, snapshot) {
                              if (snapshot.data == BluetoothDeviceState.connected) {
                                // call the discoverService 
                                // print("Discovering Services()...................");
                                discoverServices(d);
                                
                                return ElevatedButton(
                                  child: const Text('OPEN'),
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DeviceScreen(device: d))),
                                );
                              }
                              print(snapshot.data.toString());
                              return Text(snapshot.data.toString());
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                            result: r,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  r.device.connect();
                                  print("Selected device is : ${r.device.name}");
                                  return DeviceScreen(device: r.device);
                                }),
                              );
                            }),
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
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }

}

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  // @override
  // void initState() {
  //   super.initState();
  //   discoverServices();
  // }

   // Discover the services and characteristics of the device
  void discoverServices() async {
    BluetoothCharacteristic characteristic;
    print("Discovering services------------------------------------- ");
    // print("Sleeping");
    // sleep(const Duration(seconds: 10));
    List<BluetoothService> servs = await widget.device.discoverServices();
    servs.forEach(
      (service) {
        if (service.uuid.toString() == "4fafc201-1fb5-459e-8fcc-c5c9c331914b") {
          // Replace XXXX with the UUID of the service
          service.characteristics.forEach(
            (c) {
              if (c.uuid.toString() == "beb5483e-36e1-4688-b7f5-ea07361b26a8") {
                // Replace YYYY with the UUID of the characteristic
                print("!!!!!!!!!!Characteristic is matched");
                characteristic = c;
                subscribeToCharacteristic(characteristic);
              }
            },
          );
        }
      },
    );
    // print('Service not found');
  }

  // Subscribe to the characteristic to receive notifications
  void subscribeToCharacteristic(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);
    characteristic.value.listen(
      (value) async {
        // Handle the received message
        String message = String.fromCharCodes(value);
        print("message is : $message");
        if (message == 'accident') {
          // sleep(const Duration(seconds: 5));
          await characteristic.write(utf8.encode('Response'));
          print('!!!!!!!!!!Response sent');
        }
      },
    );
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () async {
                      await c.write(_getRandomBytes(), withoutResponse: true);
                      await c.read();
                    },
                    onNotificationPressed: () async {
                      await c.setNotifyValue(!c.isNotifying);
                      await c.read();
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write(_getRandomBytes()),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: StreamBuilder<BluetoothDeviceState>(
        stream: widget.device.state,
        initialData: BluetoothDeviceState.connecting,
        builder: (context, snapshot) {
          if (snapshot.data == BluetoothDeviceState.connected) {
            // discoverServices();
          }
          return Center(
            child: Text(
              'Device state: ${snapshot.data}',
            ),
          );
        },
      ),
    );
  }
 
}
