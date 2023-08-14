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

    function spawnRandomDuo(team) {
        var e = createRandomPuyo(team);
        engine.addEntity(e);
        var e = createRandomPuyo(team);
        engine.addEntity(e);
        e.get(Puyo).row++;
        e.get(Control).second = true;
    }

    function checkForSpawn(team) {
        var count = Main.instance.countEntities(team, Fall);

        if(count == 0) {
            spawnRandomDuo(team);
        }
    }
}
