package;

import js.Browser.window;
import js.Browser.document;

class Main {
    public static var instance:Main;

    static function main() {
        window.onload = ()->new Main();
    }

    var canvas:js.html.CanvasElement;
    var ctx:js.html.CanvasRenderingContext2D;
    var images:Map<String, js.html.Image> = new Map();
    var engine:ecs.Engine;
    var lastTime = 0.0;
    public var keys:Dynamic = {};
    public var previousKeys:Dynamic = {};

    public var session = new game.Session();

    function new() {
        instance = this;
        loadImages();
        initHtml();
        initGame();
        loop(0);
    }

    function initHtml() {
        canvas = cast document.getElementById("c");
        ctx = canvas.getContext("2d");
        canvas.width = canvas.height = 64;
        untyped onkeydown = onkeyup = function(e) {
            keys[e.key] = e.type[3] == 'd';
        }
    }

    function initGame() {
        engine = new ecs.Engine();
        engine.addSystem(new game.GameSystem(), 0);
        engine.addSystem(new game.FallSystem(), 1);
        engine.addSystem(new game.ControlSystem(), 1);
        engine.addSystem(new game.PuyoSystem(), 6);
        engine.addSystem(new core.SpriteSystem(), 100);
    }

    function loadImages() {
        loadImage("background");
        loadImage("puyo_red");
        loadImage("puyo_green");
        loadImage("puyo_blue");
    }

    function loadImage(name) {
        var image = new js.html.Image();
        image.src = "../data/" + name + ".png";
        images[name] = image;
    }

    function render() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = "red";
        ctx.fillRect(0, 0, 12, 12);
        ctx.drawImage(images["background"], 0, 0);
    }

    function loop(time:Float) {
        var deltaTime = (time - lastTime) / 1000;
        lastTime = time;
        render();
        engine.update(deltaTime);
        previousKeys = js.lib.Object.assign({}, keys);
        js.Browser.window.requestAnimationFrame(loop);
    }

    public function draw(image, x, y) {
        ctx.drawImage(images[image], x, y);
    }

    public function isPressed(k:String) {
        return untyped keys[k];
    }

    public function isJustPressed(k:String) {
        return untyped !previousKeys[k] && untyped keys[k];
    }
}
