import 'package:hive/hive.dart';
import '../models/data.dart';

class DatabaseServiceHive {
  final String boxName = 'preferences';

  Future<void> initializeBoxWithDefaults() async {
    final box = await Hive.openBox<MyUserData>(boxName);

    // Check if 'userData' exists; if not, set default values
    if (!box.containsKey('userData')) {
      print("Initializing with default values");
      final defaultData = MyUserData(colors: 'normal', model: 'dandelion');
      await box.put('userData', defaultData);
    }
  }

  Future<void> updateUserData(String theme, String model) async {
    print("Saving settings locally");
    final box = await Hive.openBox<MyUserData>(boxName);
    final userData = MyUserData(colors: theme, model: model);
    await box.put('userData', userData); // Save data with a fixed key
  }

  MyUserData? getUserData() {
    print("Retrieving settings locally");
    final box = Hive.box<MyUserData>(boxName);
    return box.get('userData'); // Retrieve data with the same key
  }

  Stream<MyUserData?> get dataStream async* {
    final box = await Hive.openBox<MyUserData>(boxName);

    // Ensure the box has base values if it's empty
    if (!box.containsKey('userData')) {
      print("Populating with base values");
      final defaultData = MyUserData(colors: 'lightTheme', model: 'defaultModel');
      await box.put('userData', defaultData);
    }

    // Start streaming data
    while (true) {
      await Future.delayed(Duration(milliseconds: 500)); // Polling interval
      yield box.get('userData');
    }
  }
}