package game;

class FallSystem extends ecs.System {
    var timeLeft = 1.0;
    var falling = false;

    public function new() {
        super();
        addComponentClass(math.Transform);
        addComponentClass(Puyo);
        addComponentClass(Fall);
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

        if(falling) {
            if(Main.instance.session.isValid(puyo.col, puyo.row-1)) {
                puyo.row--;
            } else {
                Main.instance.session.setGrid(puyo.col, puyo.row, e);
                e.remove(Fall);
                var es = engine.getMatchingEntities(Control);

                for(e in es) {
                    e.remove(Control);
                }
            }
        }
    }
}
