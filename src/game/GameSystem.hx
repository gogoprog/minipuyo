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
            var e = Factory.createPuyo();
            engine.addEntity(e);
            e.add(new Fall());
            e.add(new Control());
        }
    }
}
