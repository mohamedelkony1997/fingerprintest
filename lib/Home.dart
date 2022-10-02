import 'package:fingerprint/second.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LocalAuthentication auth =LocalAuthentication();
  late bool _canchechbiometric=false;
  late List<BiometricType>_biometrictypes=[];
String autherized= "not autherazed";
  Future<void>_authenticate()async{
    bool authenticated=false;
    try{
      authenticated= await auth.authenticate(
          localizedReason:
          'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: false,
            biometricOnly: true,
          ));

    }on PlatformException catch(e){
      print(e);

    }
    setState(() {
      autherized=authenticated ?'Authorized' : 'Not Authorized';
      if(authenticated){
        Navigator.push(context, MaterialPageRoute(builder: (context) => second(),));
      }
      print(autherized);

    });

  }
Future<void> _checkbiometric()async{
  bool cancheckbiometric=false;
  try{
    cancheckbiometric=await auth.canCheckBiometrics;
  }on PlatformException catch(e){
    print(e);

  }
  if(!mounted) return;
  setState(() {
    _canchechbiometric = cancheckbiometric;

  });
}
Future<void>_getavailablebiometric()async{
  List<BiometricType>biometrictypes=[];
  try{
    biometrictypes=await auth.getAvailableBiometrics();
  }on PlatformException catch(e){
    print(e);

  }
  setState(() {
    _biometrictypes = biometrictypes;

  });
}

@override
  void initState() {
    // TODO: implement initState
  _checkbiometric();
  _getavailablebiometric();


  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.grey[600],
        body: Container(
padding: EdgeInsets.all(50),
          child: Column(
            
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Center(
    child: Text('Login',
    style: TextStyle(
    color: Colors.white,
    fontSize: 35,
    ),
    ),
    ),
    Container(
    margin: EdgeInsets.all(50),
    child: Column(
    children: [
    Image(image: AssetImage("assets/finger.svg"), width: 250, height: 300),
      Text("FingetAuthathentacation",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    ],
    ),
    ),

ElevatedButton(
    style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),

            )
                
        ),

   ),

  onPressed: (){
_authenticate();
},
  child: Padding(
    padding: EdgeInsets.all(20),
    child: Text("Authenticate",
    style: TextStyle(
      color: Colors.white,
      fontSize: 15,
    ),
),
  ),
),

    ],
    ),
        ),
      );
  }
}
