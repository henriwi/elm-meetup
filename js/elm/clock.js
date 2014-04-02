Elm.Main = Elm.Main || {};
Elm.Main.make = function (_elm) {
   "use strict";
   _elm.Main = _elm.Main || {};
   if (_elm.Main.values)
   return _elm.Main.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _E = _N.Error.make(_elm),
   _J = _N.JavaScript.make(_elm),
   $moduleName = "Main";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var _op = {};
   var hand = F3(function (clr,
   len,
   time) {
      return function () {
         var angle = Basics.degrees(90 - 6 * Time.inSeconds(time));
         return Graphics.Collage.traced(Graphics.Collage.solid(clr))(A2(Graphics.Collage.segment,
         {ctor: "_Tuple2",_0: 0,_1: 0},
         {ctor: "_Tuple2"
         ,_0: len * Basics.cos(angle)
         ,_1: len * Basics.sin(angle)}));
      }();
   });
   var clock = function (t) {
      return A3(Graphics.Collage.collage,
      400,
      400,
      _J.toList([A2(Graphics.Collage.filled,
                Color.lightGrey,
                A2(Graphics.Collage.ngon,
                12,
                110))
                ,A2(Graphics.Collage.outlined,
                Graphics.Collage.solid(Color.grey),
                A2(Graphics.Collage.ngon,
                12,
                110))
                ,A3(hand,Color.orange,100,t)
                ,A3(hand,
                Color.charcoal,
                100,
                t / 60)
                ,A3(hand,
                Color.charcoal,
                60,
                t / 720)]));
   };
   var main = A2(Signal.lift,
   clock,
   Time.every(Time.second));
   _elm.Main.values = {_op: _op
                      ,main: main
                      ,clock: clock
                      ,hand: hand};
   return _elm.Main.values;
};