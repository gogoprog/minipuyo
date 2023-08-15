package game;

class GameSystem extends ecs.System {
    public function new() {
        super();
    }

    override public function onResume() {
        var e = Factory.createPuyoDisplay("red");
        var p = e.get(math.Transform).position;
        p.x = 27;
        p.y = 7;
        engine.addEntity(e);
        var e = Factory.createPuyoDisplay("blue");
        var p = e.get(math.Transform).position;
        p.x = 27;
        p.y = 11;
        engine.addEntity(e);
    }

    override public function update(dt) {
        checkForSpawn(0);
        checkForSpawn(1);
    }

    function createRandomPuyo(team) {
        var r = Std.random(Main.instance.session.colors.length);
        var color = Main.instance.session.colors[r];
        var e = Factory.createPuyo(color);
        e.add(new Fall());
        e.add(new Control());
        e.get(Puyo).team = team;
        return e;
    }

    function createGarbagePuyo(team) {
        var color = "grey";
        var e = Factory.createPuyo(color);
        e.add(new Fall());
        e.add(new Garbage());
        e.get(Puyo).team = team;
        e.get(Puyo).garbage = true;
        return e;
    }

    function spawnRandomDuo(team) {
        var e = createRandomPuyo(team);
        engine.addEntity(e);
        var e = createRandomPuyo(team);
        engine.addEntity(e);
        e.get(Puyo).row++;
        e.get(Control).second = true;
    }

    function checkForSpawn(team) {
        var main = Main.instance;
        var session = main.session;
        var count = main.countEntities(team, Fall);

        if(count == 0) {
            var garbages = session.garbages;

            if(garbages[team] > 0) {
                var row_offset = 0;

                while(garbages[team] >= 6) {
                    for(i in 0...6) {
                        var e = createGarbagePuyo(team);
                        e.get(Puyo).col = i;
                        e.get(Puyo).row += row_offset;
                        engine.addEntity(e);
                    }

                    garbages[team] -= 6;
                    row_offset++;
                }

                var coldone = new Map<Int, Bool>();

                while(garbages[team] > 0) {
                    var r = Std.random(6);

                    while(coldone[r]) {
                        r = Std.random(6);
                    }

                    coldone[r] = true;
                    var e = createGarbagePuyo(team);
                    e.get(Puyo).col = r;
                    e.get(Puyo).row += row_offset;
                    engine.addEntity(e);
                    garbages[team] -= 1;
                }
            } else {
                spawnRandomDuo(team);
                var n = session.currentMatchCounts[team] - 1;

                if(n >= 0) {
                    session.preGarbages[team] += n*(n*n + 1);
                    var total = session.preGarbages[team];
                    session.preGarbages[team] = 0;
                    session.garbages[1 - team] += total;
                    session.currentMatchCounts[team] = 0;
                }
            }
        }
    }
}
