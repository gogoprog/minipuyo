package game;

class FallSystem extends ecs.System {
    var timeLefts = [1.0, 1.0];
    var fallings = [false, false];

    public function new() {
        super();
        addComponentClass(math.Transform);
        addComponentClass(Puyo);
        addComponentClass(Fall);
    }

    override public function update(dt:Float) {
        var main = Main.instance;

        for(team in 0...2) {
            var control_count = main.countEntities(team, Control);
            var garbage_count = main.countEntities(team, Garbage);
            var fall_count = main.countEntities(team, Fall);

            if(control_count == 0) {
                timeLefts[team] -= 3 * dt;

                if(garbage_count == fall_count) {
                    timeLefts[team] -= 4 * dt;
                }
            }

            timeLefts[team] -= dt;
            fallings[team] = false;

            while(timeLefts[team] <= 0) {
                timeLefts[team] += 1.0;
                fallings[team] = true;
                var es = main.getEntities(team, Fall);

                for(e in es) {
                    var puyo = e.get(Puyo);

                    if(!main.session.isFree(puyo.team, puyo.col, puyo.row-1)) {
                        main.session.setGrid(puyo.team, puyo.col, puyo.row, e);
                        e.remove(Fall);
                        var es = main.getEntities(team, Control);

                        for(e in es) {
                            e.remove(Control);
                        }
                    }
                }
            }
        }

        super.update(dt);
    }

    override public function updateSingle(dt:Float, e:ecs.Entity) {
        var puyo = e.get(Puyo);
        var team = puyo.team;
        var main = Main.instance;

        if(fallings[team]) {
            if(main.session.isFree(puyo.team, puyo.col, puyo.row-1)) {
                puyo.row--;
            } else {
                main.session.setGrid(puyo.team, puyo.col, puyo.row, e);
                e.remove(Fall);
                var es = main.getEntities(team, Control);

                for(e in es) {
                    e.remove(Control);
                }
            }
        }
    }
}
