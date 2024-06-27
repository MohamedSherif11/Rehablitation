import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector64;

class ArScreen extends StatefulWidget {
  const ArScreen({super.key});

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {

  ArCoreController? coreController;

  augmentedRealityViewCreated(ArCoreController controller){
    
    coreController = controller;

    displayCube(coreController!);
    displayCylinder(coreController!);
  }

  displayCylinder(ArCoreController controller){

    final materials = ArCoreMaterial(
      color: Colors.deepOrange,
      reflectance: 2,
    );

    final cylinder = ArCoreCylinder(
      materials: [materials],
      radius: 0.5,
      height: 0.5
    );

    final node = ArCoreNode(
      shape: cylinder,
      position: vector64.Vector3(0.0, -0.5, -2.0),
    );

    coreController!.addArCoreNode(node);
  }


  displayCube(ArCoreController controller){
    
    final materials = ArCoreMaterial(
      color: Colors.amberAccent,
      metallic: 2,
    );
    
    final cube = ArCoreCube(
        size: vector64.Vector3(0.5, 0.5, 0.5),
        materials: [materials],
    );

    final node = ArCoreNode(
      shape: cube,
      position: vector64.Vector3(-0.5, 0.5, -3.5),
    );
    
    coreController!.addArCoreNode(node);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArCoreView(
        onArCoreViewCreated: augmentedRealityViewCreated,
      ),
    );
  }
}