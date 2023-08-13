package game;

class GameSystem extends ecs.System {
    public function new() {
        super();
    }

    override public function onResume() {
        var e = Factory.createPuyoDisplay("red");
        var p = e.get(math.Transform).position;
        p.x = 27;
        p.y = 7;
        engine.addEntity(e);
        var e = Factory.createPuyoDisplay("blue");
        var p = e.get(math.Transform).position;
        p.x = 27;
        p.y = 11;
        engine.addEntity(e);
    }

    override public function update(dt) {
        var es = engine.getMatchingEntities(Fall);

        if(es.length == 0) {
            var r = Std.random(Main.instance.session.colors.length);
            var color = Main.instance.session.colors[r];
            var e = Factory.createPuyo(color);
            engine.addEntity(e);
            e.add(new Fall());
            e.add(new Control());
            var r = Std.random(Main.instance.session.colors.length);
            var color = Main.instance.session.colors[r];
            var e = Factory.createPuyo(color);
            engine.addEntity(e);
            e.add(new Fall());
            e.add(new Control());
            e.get(Puyo).row++;
            e.get(Control).second = true;
        }
    }
}
