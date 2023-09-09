package game;

class BotSystem extends ecs.System {

    public function new() {
        super();
    }

    override public function onResume() {
    }

    override public function update(dt) {
        var main = Main.instance;
        var cr = main.session.controlRequests[1];


        cr.left = Std.random(10) < 5 ? 0 : -1;
        cr.right = Std.random(10) < 5 ? 0 : -1;
        cr.down = Std.random(10) < 5 ? 0 : -1;
        cr.rotate = Std.random(10) < 5 ? 0 : -1;
        cr.rotate2 = Std.random(10) < 5 ? 0 : -1;
    }
}
