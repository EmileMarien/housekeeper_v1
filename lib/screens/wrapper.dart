import 'package:housekeeper_v1/features/authentication/states/handler.dart';

import '../commons.dart';

class Wrapper extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    
    final user =  Provider.of<AppState>(context);
    
     if(user == null)
     {
       return Handler();
     }else
     {
       return Home();
     }

  }
} 