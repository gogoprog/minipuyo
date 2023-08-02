package game;

class PuyoSystem extends ecs.System {

    public function new() {
        super();
        addComponentClass(math.Transform);
        addComponentClass(Puyo);
    }

    override public function updateSingle(dt:Float, e:ecs.Entity) {
        var puyo = e.get(Puyo);
        var pos = e.get(math.Transform).position;
        pos.x = 2 + 4*puyo.col;
        pos.y = 64 - 11 - 4- 4*puyo.row;
    }
}
