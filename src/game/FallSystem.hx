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
        for(team in 0...2) {
            if(Main.instance.countEntities(team, Control) == 0) {
                timeLefts[team] -= 3 * dt;
            }

            timeLefts[team] -= dt;
            fallings[team] = false;

            while(timeLefts[team] <= 0) {
                timeLefts[team] += 1.0;
                fallings[team] = true;
                var es = engine.getMatchingEntities(Fall);

                for(e in es) {
                    var puyo = e.get(Puyo);

                    if(puyo.team == team) {
                        if(!Main.instance.session.isFree(puyo.team, puyo.col, puyo.row-1)) {
                            Main.instance.session.setGrid(puyo.team, puyo.col, puyo.row, e);
                            e.remove(Fall);
                            var es = engine.getMatchingEntities(Control);

                            for(e in es) {
                                if(e.get(Puyo).team == team) {
                                    e.remove(Control);
                                }
                            }
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

        if(fallings[team]) {
            if(Main.instance.session.isFree(puyo.team, puyo.col, puyo.row-1)) {
                puyo.row--;
            } else {
                Main.instance.session.setGrid(puyo.team, puyo.col, puyo.row, e);
                e.remove(Fall);
                var es = engine.getMatchingEntities(Control);

                for(e in es) {
                    if(e.get(Puyo).team == team) {
                        e.remove(Control);
                    }
                }
            }
        }
    }
}
