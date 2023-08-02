package game;

class PuyoSystem extends ecs.System {
    var timeLeft = 1.0;
    var falling = false;

    public function new() {
        super();
        addComponentClass(math.Transform);
        addComponentClass(Puyo);
    }

    override public function update(dt:Float) {
        timeLeft -= dt;
        falling = false;

        while(timeLeft <= 0) {
            timeLeft += 1.0;
            falling = true;
        }

        super.update(dt);
    }

    override public function updateSingle(dt:Float, e:ecs.Entity) {
        var puyo = e.get(Puyo);
        var pos = e.get(math.Transform).position;

        if(falling) {
            puyo.row--;
        }

        pos.x = 2 + 4*puyo.col;
        pos.y = 64 - 11 - 4- 4*puyo.row;
    }
}
