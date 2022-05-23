import 'package:flutter/material.dart';

const Color lightBrown = Color.fromARGB(255, 205, 193, 180);
const Color darkBrown = Color.fromARGB(255, 187, 173, 160);
const Color tan = Color.fromARGB(255, 238, 228, 218);
const Color greyText = Color.fromARGB(255, 119, 110, 101);

const Map<int, color> numTileColor =
{
    2: tan,
    4: tan,
    8: Color.fromARGB(255, 242, 177, 121),
    16: Color.fromARGB(255, 245, 149, 99),
    32: Color.fromARGB(255, 246, 124, 95),
    64: const Color.fromARGB(255, 246, 95, 64),
    128: const Color.fromARGB(255, 235, 208, 117),
    256: const Color.fromARGB(255, 237, 203, 103),
    512: const Color.fromARGB(255, 236, 201, 85),
    1024: const Color.fromARGB(255, 229, 194, 90),
    2048: const Color.fromARGB(255, 232, 192, 70),
}

void main()
{
    runApp(Ori-doi_App());
}

class Tile{
    final int x;
    final int y;
    int val;
    Animation<double> animatedX;
    Animation<double> animatedY;
    Animation<int> animatedValue;
    Animation<double> scale

    Tile(this.x, this.y, this.val){
        resetAnimations();
    }
    void resetAnimation() {
        animatedX = AlwaysStoppedAnimation(this.x.toDouble());
        animatedY = AlwaysStoppedAnimation(this.y.toDouble());
        animatedValue = AlwaysStoppedAnimation(this.val);
        scale = AlwaysStoppedAnimation(1.0);
    }
}



class Ori-doi_App extends StatelessWidget
{
    @override
    Widget build(BuildContext context)
    {
        return MaterialApp(
            title: 'doomipatrusopt',
            home: Ori-doi(),
        );
    }
}

class Ori-doi extends StatefulWidget
{
    @override
    Ori-doi_State createState() => Ori-doi_State();
}

class Ori-doi_State extends State<Ori-doi>
{
    List<List<Tile>> grid = List.generate(4, (y)=>List.generate(4, (x) => Tile(x, y, 0)))
    Iterable<Tile> get flattenedGrid=>grid.expand((e)=>e);
    @override
    Widget build(BuildContext context){
        double gridSize = MediaQuery.of(context).size.width - 16.0 * 2;
        double tileSize = (gridSize - 4.0 * 2)/4;
        return Scaffold(
            backgroundColor: tan,
            body: Center(
                    child: Container(
                        width: gridSize,
                        height: gridSize,
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0), color: darkBrown),

                    ),
                ),
            ),
        );
    }
}