package gameObjects;

import js.html.Console;
import com.collision.platformer.CollisionGroup;
import kha.math.FastVector2;
import com.gEngine.helpers.Screen;
import states.GlobalGameData;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Ball extends Entity{

    var ballSprite:Sprite;
    var collision:CollisionBox;
    private var ballRadio:Float;
    var velocity:FastVector2;
    private static inline var gravity:Float=2000;
    var screenWidth = Screen.getWidth();
    var screenHeight = Screen.getHeight();
    var ballType:Int;
    var sizeMultiplier:Float;
    
    public function new(x:Float, y:Float, type:Int, direction:Float, collisionGroup:CollisionGroup) {
        super();        
        velocity = new FastVector2(500,500);
        velocity.x*=direction;
        ballSprite=new Sprite("ball");
        ballSprite.x=x;
        ballSprite.y=y;
        ballType = type;
        sizeMultiplier = type/2;
        ballRadio = Std.int(ballSprite.width()*sizeMultiplier);
        ballSprite.scaleX = sizeMultiplier;
        ballSprite.scaleY = sizeMultiplier;
		GlobalGameData.simulationLayer.addChild(ballSprite);
		collision = new CollisionBox();
		collision.width = ballRadio;
		collision.height = ballRadio;
		collision.x = x;
		collision.y = y;
        collision.staticObject=true;
        collisionGroup.add(collision);
		collision.userData=this;

    }

    override function update(dt:Float) {
        velocity.y += gravity*dt;
        collision.x += velocity.x*dt;
        collision.y += velocity.y*dt;
        if(collision.y+ballRadio>=screenHeight && velocity.y>0 ){
            velocity.y*=-1;
            collision.y=screenHeight-ballRadio+(screenHeight-(collision.y+ballRadio));
        }
        if(collision.x-ballRadio<0 ||collision.x+ballRadio>screenWidth){
            velocity.x*=-1;
        }
        super.update(dt);
    }

    override function render() {
		super.render();
		ballSprite.x = collision.x;
		ballSprite.y = collision.y;
	}

    override function destroy() {
        super.destroy();
        ballSprite.removeFromParent();
        collision.removeFromParent();
    }

    public function getType(){
        return ballType;
    }

    public function getX(){
        return collision.x;
    }

    public function getY(){
        return collision.y;
    }
    
}