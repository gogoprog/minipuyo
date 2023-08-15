package game;

typedef Match = Map<ecs.Entity, Bool>;

class CheckSystem extends ecs.System {
    static var requiredMatchCount = 2;

    public function new() {
        super();
    }

    override public function onResume() {
    }

    override public function update(dt) {
        for(team in 0...2) {
            var count = Main.instance.countEntities(team, Fall);

            if(count == 0) {
                var main = Main.instance;
                var session = main.session;
                var matches = new Array<Match>();

                for(x in 0...session.width) {
                    for(y in 0...session.height) {
                        var e = session.getEntity(team, x, y);

                        if(e != null) {
                            var match:Match = null;

                            for(m in matches) {
                                if(m[e]) {
                                    match = m;
                                }
                            }

                            if(match == null) {
                                var puyo = e.get(Puyo);

                                if(!puyo.garbage) {
                                    match = new Match();
                                    matches.push(match);
                                    var current = puyo.getPosition();
                                    match[e] = true;
                                    visit(team, match, current, puyo.color);
                                }
                            }
                        }
                    }
                }

                var did_match = false;

                for(match in matches) {
                    var size = Lambda.count(match);

                    if(size >= requiredMatchCount) {
                        did_match = true;

                        for(e in match.keys()) {
                            var puyo = e.get(Puyo);
                            Main.instance.session.setGrid(team, puyo.col, puyo.row, null);
                            engine.removeEntity(e);
                        }
                    }
                }

                if(did_match) {
                    var es = engine.getMatchingEntities(Puyo);

                    for(e in es) {
                        var puyo = e.get(Puyo);

                        if(puyo.team == team) {
                            Main.instance.session.setGrid(team, puyo.col, puyo.row, null);
                            e.add(new Fall());
                        }
                    }
                }
            }
        }
    }

    function visit(team:Int, match:Match, position:math.Point, color) {
        var deltas:Array<math.Point> = [ [0, 1], [0, -1], [1, 0], [-1, 0]];

        for(delta in deltas) {
            var new_pos = position + delta;
            var e = Main.instance.session.getEntity(team, Std.int(new_pos.x), Std.int(new_pos.y));

            if(e != null) {
                if(e.get(Puyo).color == color) {
                    if(!match[e]) {
                        match[e] = true;
                        visit(team, match, new_pos, color);
                    }
                }
            }
        }
    }
}
