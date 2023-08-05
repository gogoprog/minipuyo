package game;

class GameSystem extends ecs.System {
    public function new() {
        super();
    }

    override public function onResume() {
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
        }
    }
}
