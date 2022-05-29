import 'package:flutter/material.dart';

const Color lightBrown = Color.fromARGB(255, 205, 193, 180);
const Color darkBrown = Color.fromARGB(255, 187, 173, 160);
const Color tan = Color.fromARGB(255, 238, 228, 218);
const Color greyText = Color.fromARGB(255, 119, 110, 101);

const Map<int, Color> numTileColor =
{
    2: tan,
    4: Color.fromARGB(255, 237, 224, 200),
    8: Color.fromARGB(255, 242, 177, 121),
    16: Color.fromARGB(255, 245, 149, 99),
    32: Color.fromARGB(255, 246, 124, 95),
    64: const Color.fromARGB(255, 246, 95, 64),
    128: const Color.fromARGB(255, 235, 208, 117),
    256: const Color.fromARGB(255, 237, 203, 103),
    512: const Color.fromARGB(255, 236, 201, 85),
    1024: const Color.fromARGB(255, 229, 194, 90),
    2048: const Color.fromARGB(255, 232, 192, 70),
};

void main()
{
    runApp(ori_doiApp());
}

class Tile
{
    final int x;
    final int y;
    int val;
    Animation<double> animatie_x;
    Animation<double> animatie_y;
    Animation<int> animatie_val;
    Animation<double> scale;
    Tile(this.x, this.y, this.val)
    {
        resetAnimatii();
    }
    void resetAnimatii()
    {
        animatie_x = AlwaysStoppedAnimation(this.x.toDouble());
        animatie_y = AlwaysStoppedAnimation(this.y.toDouble());
        animatie_val = AlwaysStoppedAnimation(this.val);
        scale = AlwaysStoppedAnimation(1.0);
    }
    void moveTo(Animation<double> parent, int x, int y){
        animatie_x = Tween(begin: this.x.toDouble(), end: x.toDouble())
            .animate(CurvedAnimation(parent: parent, curve: Interval(0, .5)));
        animatie_y = Tween(begin: this.y.toDouble(), end: y.toDouble())
            .animate(CurvedAnimation(parent: parent, curve: Interval(0, .5)));
    }
    void bounce(Animation<double> parent){
        scale = TweenSequence([
            TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1.0),
            TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1.0),
        ]).animate(CurvedAnimation(parent: parent, curve: Interval(.5, 1.0)));
    }

    void appear(Animation<double> parent){
        scale = Tween(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: parent, curve: Interval(.5, 1.0)));
    }

    void schimbareNumar(Animation<double> parent, int new_val){
        animatie_val = TweenSequence([
            TweenSequenceItem(tween: ConstantTween(val), weight: .01),
            TweenSequenceItem(tween: ConstantTween(new_val), weight: .99),
        ])
            .animate(CurvedAnimation(parent: parent, curve: Interval(.5, 1.0)));
    }

}

class ori_doiApp extends StatelessWidget
{
    @override
    Widget build(BuildContext context)
    {
        return MaterialApp(
            title: '2048',
            home: ori_doi(),
        );
    }
}

class ori_doi extends StatefulWidget
{
    @override
    ori_doiState createState() => ori_doiState();
}

class ori_doiState extends State<ori_doi> with TickerProviderStateMixin
{
    AnimationController controller;
    List<List<Tile>> grid = List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, 0)));
    List<Tile> toAdd = [];
    Iterable<Tile> get flattenedGrid => grid.expand((e) => e);
    Iterable<List<Tile>> get cols => List.generate(4, (x) => List.generate(4, (y) => grid[y][x]));

    @override
    void initState()
    {
        super.initState();
        controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
        controller.addStatusListener((status)  {if (status == AnimationStatus.completed){
            toAdd.forEach((element){grid[element.y][element.x].val = element.val;
            });
            flattenedGrid.forEach((element) {
                element.resetAnimatii();
            });
            toAdd.clear();
        }
        });
        
        grid[1][2].val = 4;
        grid[0][2].val = 2;
        grid[3][2].val = 2;
        
        flattenedGrid.forEach((element) => element.resetAnimatii());
    }

    void adaugaTile(){
        List<Tile> empty = flattenedGrid.where((e) => e.val == 0).toList();
        empty.shuffle();
        toAdd.add(Tile(empty.first.x, empty.first.y, 2)..appear(controller));
    }

    @override
    Widget build(BuildContext context)
    {
        double gridSize = MediaQuery.of(context).size.width - 16.0 * 2;
        double tileSize = (gridSize - 4.0 * 2) / 4;
        List<Widget> stackItems = [];
        stackItems.addAll(flattenedGrid.map((e) => Positioned(
            left: e.x * tileSize,
            top: e.y * tileSize,
            width: tileSize,
            height: tileSize,
            child: Center(
                child: Container(
                    width: tileSize - 4.0 * 2,
                    height: tileSize - 4.0 * 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0), color: lightBrown),
            )),
        )));
        stackItems.addAll([flattenedGrid, toAdd].expand((e) => e).map((e) => AnimatedBuilder(animation: controller, builder: (context, child) => e.animatie_val.value == 0 ? SizedBox() : Positioned(
            left: e.animatie_x.value * tileSize,
            top: e.animatie_y.value * tileSize,
            width: tileSize,
            height: tileSize,
            child: Center(
                child: Container(
                    width: (tileSize - 4.0 * 2) * e.scale.value,
                    height: (tileSize - 4.0 * 2) * e.scale.value,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: numTileColor[e.animatie_val.value]),
                        child: Center(
                            child: Text(
                                "${e.animatie_val.value}",
                                style: TextStyle(
                                    color: e.animatie_val.value <= 4 ? greyText : Colors.white,
                                    fontSize: 35, fontWeight: FontWeight.w900),
                                )
                            ))),
        ))));

        return Scaffold(
            backgroundColor: tan,
            body: Center(
                child: Container(
                    width: gridSize,
                    height: gridSize,
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0), color: darkBrown),
                    child: GestureDetector(
                        onVerticalDragEnd: (details) {
                            if (details.velocity.pixelsPerSecond.dy < -250 && mergeSus()) {
                                faSwipe(swipeSus);
                            }
                            else if (details.velocity.pixelsPerSecond.dx > 250 && mergeJos()) {
                                faSwipe(swipeJos);
                            }
                        },
                        onHorizontalDragEnd: (details) {
                            if (details.velocity.pixelsPerSecond.dx < -1000 && mergeStanga()) {
                                faSwipe(swipeStanga);
                            }
                            else if (details.velocity.pixelsPerSecond.dx > 1000 && mergeDreapta()) {
                                faSwipe(swipeDreapta);
                            }
                        },
                        child: Stack(
                            children: stackItems,
                )),
            )),
        );
    }

    void faSwipe(void Function() swipeFn)
    {
        setState(() {
            swipeFn();
            adaugaTile();
            controller.forward(from: 0);
        });
    }
    bool mergeStanga() => grid.any(swipe);
    bool mergeDreapta() => grid.map((e) => e.reversed.toList()).any(swipe);
    bool mergeSus() => cols.any(swipe);
    bool mergeJos() => cols.map((e) => e.reversed.toList()).any(swipe);

    bool swipe(List<Tile> tiles)
    {
        for(int i=0;i<tiles.length;i++)
            {
                if(tiles[i].val == 0)
                    {
                        if(tiles.skip(i+1).any((e) => e.val != 0))
                        {
                            return true;
                        }
                    }
                else
                    {
                        Tile nextNonZero = tiles.skip(i+1).firstWhere((e) => e.val != 0, orElse: () => null);
                        if(nextNonZero != null && nextNonZero.val == tiles[i].val)
                            {
                                return true;
                            }
                    }
            }
        return false;
    }

    void swipeStanga() => grid.forEach(mergeTiles);
    void swipeDreapta() => grid.map((e) => e.reversed.toList()).forEach(mergeTiles);
    void swipeSus() => cols.forEach(mergeTiles);
    void swipeJos() => cols.map((e) => e.reversed.toList()).forEach(mergeTiles);

    void mergeTiles(List<Tile> tiles) {
        for (int i = 0; i < tiles.length; i++) {
            Iterable<Tile> deVerif = tiles.skip(i).skipWhile((value) =>
            value.val == 0);
            if (deVerif.isNotEmpty) {
                Tile t = deVerif.first;
                Tile merge = deVerif.skip(1).firstWhere((t) => t.val != 0,
                    orElse: () => null);
                if (merge != null && merge.val != t.val) {
                    merge = null;
                }
                if (tiles[i] != t || merge != null) {
                    int resultValue = t.val;
                    t.moveTo(controller, tiles[i].x, tiles[i].y);
                    // animeaza tile la pozitia t
                    if (merge != null) {
                        resultValue += merge.val;
                        merge.moveTo(controller, tiles[i].x, tiles[i].y);
                        merge.bounce(controller);
                        merge.schimbareNumar(controller, resultValue);
                        merge.val = 0;
                        t.schimbareNumar(controller, 0);
                    }
                    t.val = 0;
                    tiles[i].val = resultValue;
                }
            }
        }
    }
}