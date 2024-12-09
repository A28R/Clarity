import 'package:clarity/models/data.dart';
import 'package:clarity/screens/pages/settings_stuff/permission_status.dart';
import 'package:clarity/services/database_fb.dart';
import 'package:clarity/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../services/database_h.dart';
import '../../../shared/constants.dart';
import '../../../shared/loading.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final String boxName = 'preferences';
  late final DatabaseServiceHive dbService;
  late Future<void> _hiveInitFuture;

  @override
  void initState() {
    super.initState();
    dbService = DatabaseServiceHive();
    _hiveInitFuture = _initializeBox(); // Initialize the Hive box
  }

  Future<void> _initializeBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      print("no box");
      await Hive.openBox<MyUserData>(boxName); // Open or create the box
    }
    print('box made');
    print(dbService.boxName);
    print(dbService.dataStream);

  }
  final List<String> colors = [
    'normal',
    "protanopia",
    "deuteranopia",
    "tritanopia",
    "protanomaly",
    "deuteranomaly",
    "tritanomaly",
    "achromatopsia"
  ];
  final List<String> models = [
    'dandelion',
  ];
  dynamic _currentModel;
  dynamic _currentColor;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _hiveInitFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('loading')),
            body: Loading(),
          );
        }
        if (snapshot.hasError) {
          // Handle errors if Hive initialization fails
          return Scaffold(
            appBar: AppBar(title: Text('Settings')),
            body: Center(child: Text("Error initializing settings: ${snapshot.error}")),
          );
        }
        return StreamBuilder<MyUserData?>(
            stream: dbService.dataStream,
            builder: (context, snapshot) {
              return Scaffold(
                  backgroundColor: lighterTertiaryColor,
                  appBar: AppBar(
                    title: Text(
                      'SETTINGS'.toUpperCase(),
                      style: TextStyle(
                          color: lighterTertiaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 24),
                    ),
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: oppositeTertiaryColor,
                    leading: TextButton(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: tertiaryColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  body: snapshot.hasData
                      ? Builder(builder: (context) {
                    final userData = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 48.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .stretch,
                                children: <Widget>[
                                  const SizedBox(height: 24.0),
                                  Text(
                                    "Select AI Model".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 23,
                                      color: primaryColor,
                                    ),
                                  ),
                                  Text(
                                    "Models may differ in accuracy",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                      color: primaryColor.withAlpha(150),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  DropdownButtonFormField(
                                    value: _currentModel ?? userData!.model,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: tertiaryColor,
                                      contentPadding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 16, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8),
                                        borderSide: BorderSide(
                                            color: darkerSecondaryColor,
                                            width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8),
                                        borderSide: BorderSide(
                                            color: darkerSecondaryColor,
                                            width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8),
                                        borderSide: BorderSide(
                                            color: darkerSecondaryColor,
                                            width: 2),
                                      ),
                                    ),
                                    dropdownColor: lighterTertiaryColor,
                                    style: TextStyle(
                                      color: oppositeTertiaryColor,
                                      fontSize: 16,
                                    ),
                                    items: models.map((model) {
                                      return DropdownMenuItem(
                                        value: model,
                                        child: Text(
                                          "$model",
                                          style: TextStyle(
                                            color: oppositeTertiaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) =>
                                        setState(() => _currentModel = val!),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    "Select Color Scheme".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 23,
                                      color: primaryColor,
                                    ),
                                  ),
                                  Text(
                                    "Schemes are preset for colorblindness types.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                      color: primaryColor.withAlpha(150),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  DropdownButtonFormField(
                                    value: _currentColor ?? userData!.colors,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: tertiaryColor,
                                      contentPadding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 16, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8),
                                        borderSide: BorderSide(
                                            color: darkerSecondaryColor,
                                            width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8),
                                        borderSide: BorderSide(
                                            color: darkerSecondaryColor,
                                            width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8),
                                        borderSide: BorderSide(
                                            color: darkerSecondaryColor,
                                            width: 2),
                                      ),
                                    ),
                                    dropdownColor: lighterTertiaryColor,
                                    style: TextStyle(
                                      color: oppositeTertiaryColor,
                                      fontSize: 16,
                                    ),
                                    items: colors.map((color) {
                                      return DropdownMenuItem(
                                        value: color,
                                        child: Text(
                                          "$color",
                                          style: TextStyle(
                                            color: oppositeTertiaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) =>
                                        setState(() => _currentColor = val!),
                                  ),
                                  const SizedBox(height: 24.0),
                                  ElevatedButton(
                                    onPressed: () async {
                                      HapticFeedback.mediumImpact();
                                      if (_formKey.currentState!.validate()) {
                                        await dbService.updateUserData(
                                          _currentColor ?? userData!.colors,
                                          _currentModel ?? userData!.model,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: tertiaryColor,
                                      foregroundColor: oppositeTertiaryColor,
                                      padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8),
                                        side: BorderSide(
                                            color: darkerSecondaryColor,
                                            width: 2),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "Update".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 60,
                            height: 10,

                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(50)
                            ),

                          ),
                          SizedBox(height: 20,),
                          Text(
                            "Permissions".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 23,
                                color: primaryColor
                            ),
                          ),
                          // Then add these widgets in your column:
                          const SizedBox(height: 16.0),
                          buildPermissionStatus(
                            title: 'Photos Permission',
                            permission: Permission.photos,
                          ),
                          buildPermissionStatus(
                            title: 'Camera Permission',
                            permission: Permission.camera,
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    );
                  })
                      : Loading());
            });
      }
    );
  }
}
