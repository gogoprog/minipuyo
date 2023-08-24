package game;

class HudSystem extends ecs.System {

    var time = 0.0;

    public function new() {
        super();
    }

    override public function onResume() {
    }

    override public function update(dt) {
        time += dt;

        if(Main.instance.session.gameStarted) {
            display(0);
            display(1);
        } else {
            mainMenu();
        }
    }

    function display(team) {
        var main = Main.instance;
        var session = main.session;
        var ctx = main.ctx;
        ctx.fillStyle = "#500";
        var offset = team == 0 ? 3 : 39;
        var count = session.garbages[team];

        for(i in 0...count) {
            ctx.fillRect(offset, 6, 1, 3);
            offset += 2;
        }
    }

    function mainMenu() {
        var main = Main.instance;
        var session = main.session;
        var ctx = main.ctx;
        ctx.fillStyle = "#444";
        ctx.fillRect(2, 6, 60, 52);
        ctx.fillStyle = "#57e";
        ctx.font = "12px pixel";
        ctx.textBaseline = "top";
        ctx.fillText("MiniPuyo!", 4, 10);
        var draw = (Std.int(time) % 2) == 0;

        if(draw) {
            ctx.font = "10px pixel";
            ctx.fillText("Press", 18, 30);
            ctx.fillText("Enter", 18, 39);
        }

        // if(main.isJustPressed("Enter")) {
            session.gameStarted = true;
        // }
    }
}
