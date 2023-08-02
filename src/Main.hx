package;

import js.Browser.window;
import js.Browser.document;

class Main {
    static function main() {
        window.onload = ()->new Main();
    }

    var canvas:js.html.CanvasElement;
    var ctx:js.html.CanvasRenderingContext2D;
    var loadLeft = 0;
    var keys:Dynamic = {};
    var images:Map<String, js.html.Image> = new Map();

    function new() {
        canvas = cast document.getElementById("c");
        ctx = canvas.getContext("2d");
        canvas.width = canvas.height = 64;
        untyped onkeydown = onkeyup = function(e) {
            keys[e.key] = e.type[3] == 'd';
        }
        loadImage("background");
        loadImage("blob");
        loop(0);
    }

    function processControls() {
    }

    function loadImage(name) {
        var image = new js.html.Image();
        loadLeft++;
        image.onload = () -> {
            loadLeft--;
        }
        image.src = "../data/" + name + ".png";
        images[name] = image;
    }

    function render() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = "red";
        ctx.fillRect(0, 0, 12, 12);
        ctx.drawImage(images["background"], 0, 0);
        ctx.drawImage(images["blob"], 10, 10);
    }

    function loop(time:Float) {
        render();
        js.Browser.window.requestAnimationFrame(loop);
    }
}
