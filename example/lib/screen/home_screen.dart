import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:license_generator_example/util/license.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text('icapps license'),
        backgroundColor: Colors.black45,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: LicenseUtil.getLicenses().length,
          itemBuilder: (context, index) {
            final item = LicenseUtil.getLicenses()[index];
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                color: Colors.grey.withOpacity(0.5),
                child: Column(
                  children: [
                    Text(item.name),
                    Text(item.version ?? 'n/a'),
                    Text(item.homepage ?? 'n/a'),
                    Text(item.repository ?? 'n/a'),
                    Container(height: 8),
                    Text(item.license),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
