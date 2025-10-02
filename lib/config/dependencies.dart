import 'package:fake_store/fake_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fakeStoreProvider = Provider((ref) => FakeStore.instance);
