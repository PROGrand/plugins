// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:e2e/e2e.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  group('Connectivity test driver', () {
    Connectivity _connectivity;

    setUpAll(() async {
      _connectivity = Connectivity();
    });

    testWidgets('test connectivity result', (WidgetTester tester) async {
      final ConnectivityResult result = await _connectivity.checkConnectivity();
      expect(result, isNotNull);
      switch (result) {
        case ConnectivityResult.wifi:
          expect(_connectivity.getWifiName(), completes);
          expect(_connectivity.getWifiBSSID(), completes);
          // TODO: This is not implemented in macOS. Check why.
          if (!Platform.isMacOS) {
            expect((await _connectivity.getWifiIP()), isNotNull);
          }
          break;
        default:
          break;
      }
    });

    testWidgets('test location methods, iOS only', (WidgetTester tester) async {
      if (Platform.isIOS) {
        expect((await _connectivity.getLocationServiceAuthorization()),
            LocationAuthorizationStatus.notDetermined);
      }
    });
  });
}
