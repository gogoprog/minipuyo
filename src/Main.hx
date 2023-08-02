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
    var session = new game.Session();
    var lastTime = 0.0;

    public var keys:Dynamic = {};

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
        engine.addSystem(new game.PuyoSystem(), 1);
        engine.addSystem(new core.SpriteSystem(), 100);
    }

    function loadImages() {
        loadImage("background");
        loadImage("blob");
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
        js.Browser.window.requestAnimationFrame(loop);
    }

    public function draw(image, x, y) {
        ctx.drawImage(images[image], x, y);
    }
}
