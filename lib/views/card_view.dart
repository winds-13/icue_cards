/* The 3D card view screen
   [List all the cards in a deck]
   Author: Henry Tu
*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/iCueCard.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'dart:async';
import 'package:photo_view/photo_view.dart';
import '../tools/shuffle.dart';

class CardView extends StatefulWidget {
  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  StreamController<List<iCueCard>> _streamController;
  initState() {
    _streamController = StreamController<List<iCueCard>>();
    super.initState();
  }

  void _addToStream(List<iCueCard> cards, int index) {
    print(index);
    cards.add(cards[index]);
    cards.removeAt(index);
    _streamController.add(cards);
  }

  void _keepStream(List<iCueCard> cards, int index) {
    print(index);
    cards.removeAt(index);
    _streamController.add(cards);
  }

  void _refreshStream(
      List<iCueCard> oldCards, List<iCueCard> cards, bool random) {
    if (random == true) {
      shuffle(cards);
      _streamController.add(cards);
      return;
    }
    for (int i = cards.length - 1; i >= 0; i--) {
      cards.removeAt(i);
    }

    for (int i = 0; i < oldCards.length; i++) {
      cards.add(oldCards[i]);
    }

    _streamController.add(cards);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> rcvdData =
        ModalRoute.of(context).settings.arguments;
    List oldCards = rcvdData['list'];
    oldCards = oldCards.cast<iCueCard>();
    List<iCueCard> cards = new List();

    for (int i = 0; i < oldCards.length; i++) {
      cards.add(oldCards[i]);
    }

    //cards = shuffle(cards);
    String title = rcvdData['title'];
    cards = cards.cast<iCueCard>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.lightBlueAccent[500],
      ),
      body: StreamBuilder<List<iCueCard>>(
          stream: _streamController.stream,
          initialData: cards,
          builder: (BuildContext context, AsyncSnapshot<List<iCueCard>> cards) {
            //print('snapshot.data.length: ${cards.data.length}');
            if (cards.hasError) return Text('Error: ${cards.error}');
            print("build active");
            return _buildDeck(context, cards.data, oldCards);
          }),
    );
  }

  Widget _buildDeck(
      BuildContext context, List<iCueCard> cards, List<iCueCard> oldCards) {
    CardController controller;
    return Stack(
      key: UniqueKey(),
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Container(
          //entire page
          color: Colors.grey[300],
          child: TinderSwapCard(
            swipeUp: true,
            swipeDown: false,
            orientation: AmassOrientation.TOP,
            totalNum: cards.length,
            stackNum: 3,
            swipeEdge: 5.0,
            maxWidth: MediaQuery.of(context).size.width * 0.86,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minWidth: MediaQuery.of(context).size.width * 0.85,
            minHeight: MediaQuery.of(context).size.height * 0.785,
            cardBuilder: (context, index) => Container(
              child: FlipCard(
                //the card
                key: ObjectKey(cards[index]),
                direction: FlipDirection.HORIZONTAL,
                speed: 300,
                front: Container(
                  //the card
                  decoration: BoxDecoration(
                    //   boxShadow: [
                    //     BoxShadow(
                    //       //color: cards[index].getColor(),
                    //       color: Colors.grey,
                    //       blurRadius: 2.0,
                    //       spreadRadius: 0.0,
                    //       offset:
                    //           Offset(0.5, 0.5), // shadow direction: bottom right
                    //     )
                    //   ],
                    boxShadow: [
                      BoxShadow(
                        color: cards[index].getColor() == Colors.red
                            ? cards[index].getColor()
                            : Colors.grey,
                        //color: Colors.grey,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(0.5, 0.5), // shadow direction: bottom right
                      )
                    ],
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/background.png',
                      ),
                      fit: BoxFit.fitHeight,
                      colorFilter: cards[index].getColor() == Colors.red
                          ? ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.dstATop)
                          : null,
                    ),
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          cards[index].getFront(),
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                back: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          //color: cards[index].getColor(),
                          color: Colors.grey,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              0.5, 0.5), // shadow direction: bottom right
                        )
                      ],
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/background.png',
                        ),
                        fit: BoxFit.fitHeight,
                        // colorFilter: new ColorFilter.mode(
                        //     Colors.black.withOpacity(0.98), BlendMode.dstATop),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            //"dadadji d jaojd iod osd ossoo js f josdcosdfosj f;osf  dfsfj ofos fj sofj osf ofjd isij si; f jd jsf sdof jdsjjf dfj osf ofjd isij si; f jd jsf sdof jdsjjf dfj osf ofjd isij si; f jd jsf sdof jdsjjf dfj osf ofjd isij si; f jd jsf sdof jdsjjf dfj osf ofjd isij si; f jd jsf sdof jdsjjf dfj osf ofjd isij si; f jd jsf sdof jdsjjf dfj osf ofjd isij si; f jd jsf sdof jdsjjf dfj osf ofjd isij si; f jd jsf sdof jdsjjf dfj aisjfisdfjsdf sdf  fj oisdj osf ;osfj osfj ;sdfj oi;afj ;j fis j;osfj ;sa dsiafjio;sfj ;sc; josdj as jios jisofj isfa;sjf osjf s jf;idsf jsaifj;fdjso s;df jsf sf jsfj ;lsf ;ds sf idfjsifj sdfj ldf lksf msdf lsfd ;asf ;ios f; j",
                            //"dsadjajdo, dksdm; md ,s;f,ds sofkosi jdfkdsiofjos f sfijsiodfjisoj sodj fsdoiff sidjf iosdjf oj;s, dsadjajdo, dksdm; md ,s;f,ds sofkosi jdfkdsiofjos f sfijsiodfjisoj sodj fsdoiff sidjf iosdjf oj;sdsadjajdo, dksdm; md ,s;f,ds sofkosi jdfkdsiofjos f sfijsiodfjisoj sodj fsdoiff sidjf iosdjf oj;sdsadjajdo, dksdm; md ,s;f,ds sofkosi jdfkdsiofjos f sfijsiodfjisoj sodj fsdoiff sidjf iosdjf oj;s",
                            cards[index].getBack(),
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        cards[index].getImage() == null
                            ? Container()
                            : Expanded(
                                child: GestureDetector(
                                  onDoubleTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (_) => ImageDialog(
                                            cards[index].getImage()));
                                  },
                                  child: Image(
                                    image: cards[index].getImage(),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                      ],
                    )),
              ),
            ),
            cardController: controller = CardController(),
            // swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            //   /// Get swiping card's alignment
            //   if (align.x < 0) {
            //   } else if (align.x > 0) {
            //     //Card is RIGHT swiping
            //   }
            // },
            swipeCompleteCallback:
                (CardSwipeOrientation orientation, int index) {
              if (orientation == CardSwipeOrientation.LEFT) {
                _addToStream(cards, index);
              } else if (orientation == CardSwipeOrientation.RIGHT ||
                  orientation == CardSwipeOrientation.UP ||
                  orientation == CardSwipeOrientation.DOWN) {
                _keepStream(cards, index);
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  iconSize: 27.5,
                  icon: Icon(Icons.replay),
                  onPressed: () {
                    _refreshStream(oldCards, cards, false);
                  }),
              IconButton(
                  iconSize: 27.5,
                  icon: Icon(Icons.shuffle),
                  onPressed: () {
                    _refreshStream(oldCards, cards, true);
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget ImageDialog(AssetImage a) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: PhotoView(
        imageProvider: a,
      )),
    );
  }
}
