import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class HomeSs extends StatelessWidget {
  const HomeSs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RickandMorty")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Character"),
          onPressed: () {
            context.goNamed("/character");
          },
        ),
      ),
    );
  }
}
