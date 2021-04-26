package states;

import com.gEngine.GEngine;
import com.framework.utils.Random;
import kha.math.FastVector2;
import com.gEngine.display.Sprite;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class GameState extends State {

    var screenWidth:Int;
    var screenHeight:Int;
    private var ballRadio = 20;
    var ball:Sprite;
    var velocityY:Float=0;
    var gravity:Float=2000;
    override function load(resources:Resources) {
        resources.add(new ImageLoader("ball"));
        screenWidth =  1280;
        screenHeight = 720;
    }
    
    override function init() {
        ball=new Sprite("ball");
        ball.x=100;
        ball.y=100;
        ballRadio = Std.int(ball.width()*0.5);
        ball.offsetX = -ball.width() * 0.5;
        ball.offsetY = -ball.height() * 0.5;
        stage.addChild(ball);
    }
    var signX:Int=1;
    var signY:Int=1;
    override function update(dt:Float) {
       
        velocityY += gravity*dt;

        ball.x += 600*dt*signX;
        ball.y += velocityY*dt;

       if(ball.x+ballRadio >= screenWidth || ball.x-ballRadio <= 0){
           signX *= -1;
       }

        if(ball.y+ballRadio >= screenHeight && velocityY > 0 ){
            velocityY *= -0.5;
            var deltaY = (ball.y+ballRadio)-screenHeight;
            ball.y = (screenHeight-ballRadio)-deltaY;
            //ball.y=screenHeight-ballRadio;
            //velocityY=-1500;
        }
        
       

        super.update(dt);
    }
    override function render() {
        super.render();
    }
}