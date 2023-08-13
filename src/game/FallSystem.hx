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
        var es = engine.getMatchingEntities(Control);

        if(es.length == 0) {
            timeLeft -= 3 * dt;
        }

        timeLeft -= dt;
        falling = false;

        while(timeLeft <= 0) {
            timeLeft += 1.0;
            falling = true;
            var es = engine.getMatchingEntities(Fall);

            for(e in es) {
                var puyo = e.get(Puyo);

                if(!Main.instance.session.isFree(puyo.team, puyo.col, puyo.row-1)) {
                    Main.instance.session.setGrid(puyo.team, puyo.col, puyo.row, e);
                    e.remove(Fall);
                    var es = engine.getMatchingEntities(Control);

                    for(e in es) {
                        e.remove(Control);
                    }
                }
            }
        }

        super.update(dt);
    }

    override public function updateSingle(dt:Float, e:ecs.Entity) {
        var puyo = e.get(Puyo);

        if(falling) {
            if(Main.instance.session.isFree(puyo.team, puyo.col, puyo.row-1)) {
                puyo.row--;
            } else {
                Main.instance.session.setGrid(puyo.team, puyo.col, puyo.row, e);
                e.remove(Fall);
                var es = engine.getMatchingEntities(Control);

                for(e in es) {
                    e.remove(Control);
                }
            }
        }
    }
}
