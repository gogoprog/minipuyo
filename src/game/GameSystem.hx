package game;

class GameSystem extends ecs.System {
    public function new() {
        super();
    }

    override public function onResume() {
        var e = Factory.createPuyo();
        engine.addEntity(e);
    }
}
