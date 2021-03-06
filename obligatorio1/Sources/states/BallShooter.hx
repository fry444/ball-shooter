package states;

import kha.Color;
import com.gEngine.display.Text;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.JoinAtlas;
import com.framework.utils.Random;
import kha.Canvas;
import kha.math.FastVector2;
import gameObjects.Bullet;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionEngine;
import com.framework.utils.Input;
import gameObjects.Ball;
import kha.input.KeyCode;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.gEngine.helpers.Screen;
import gameObjects.Cannon;
import states.GlobalGameData;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionGroup;
import com.framework.utils.State;

class BallShooter extends State{
    var simulationLayer:Layer;
    var cannon:Cannon;
    var ballsCollision:CollisionGroup = new CollisionGroup();
    var cannonInitialX=(Screen.getWidth()/2)-20;
    var cannonInitialY=Screen.getHeight()-20;
    var cannonHealth:Float = 10;
    var kills:Float = 0;
    var healthValue:Text;
    var killsValue:Text;

    override function load(resources:Resources) {
        var atlas = new JoinAtlas(512,512);
        atlas.add(new FontLoader("Kenney_Thick",10));
        resources.add(new ImageLoader("ball"));
        resources.add(atlas);
    }

    override function init() {
        showTexts();
        simulationLayer = new Layer();
        stage.addChild(simulationLayer);
        GlobalGameData.simulationLayer = simulationLayer;
        cannon = new Cannon(cannonInitialX, cannonInitialY);
        addChild(cannon);
        GlobalGameData.cannon=cannon;        
        super.init();
    }

    function showTexts(){
        var healthText = new Text("Kenney_Thick");
        healthText.x=50;
        healthText.y=50;
        healthText.text="HEALTH";
        stage.addChild(healthText);  
        healthValue = new Text("Kenney_Thick");
        healthValue.x=120;
        healthValue.y=50;
        healthValue.text=""+cannonHealth;
        stage.addChild(healthValue);      
        var killsText = new Text("Kenney_Thick");
        killsText.x=50;
        killsText.y=100;
        killsText.text="KILLS";
        stage.addChild(killsText);  
        killsValue = new Text("Kenney_Thick");
        killsValue.x=120;
        killsValue.y=100;
        killsValue.text=""+kills;
        stage.addChild(killsValue);     
        var instruction1Text = new Text("Kenney_Thick");
        instruction1Text.x=1000;
        instruction1Text.y=50;
        instruction1Text.text="Press B to generate balls";
        stage.addChild(instruction1Text);
        var instruction2Text = new Text("Kenney_Thick");
        instruction2Text.x=1000;
        instruction2Text.y=100;
        instruction2Text.text="Press SPACE to shoot";
        stage.addChild(instruction2Text);
    }

    function updateHealthValue(){
        cannonHealth--;
        healthValue.text=""+cannonHealth;
        if(cannonHealth<7){
            healthValue.set_color(Color.Yellow);
        }else if(cannonHealth<4){
            healthValue.set_color(Color.Red);
        }
        else{
            healthValue.set_color(Color.Green);
        }
        stage.update();
    }

    function updateKillsValue(){
        kills++;
        killsValue.text=""+kills;
        stage.update();
    }

    override function update(dt:Float) {
        if(Input.i.isKeyCodePressed(KeyCode.B)){
            var randomX = Math.round(Random.getRandomIn(20,1260));
            addBall(randomX,100,3,1, new FastVector2(400,400));
        }
        CollisionEngine.overlap(cannon.collision, ballsCollision, cannonVsBall);
        CollisionEngine.overlap(cannon.bulletsCollision, ballsCollision, bulletVsBall);
        super.update(dt);
    }

    function addBall(x:Float, y:Float, ballType:Int, ballDirection:Float, ballVelocity:FastVector2){
        var ball = new Ball(x,y,ballType,ballDirection,ballVelocity, ballsCollision);
        addChild(ball);
    }

    function cannonVsBall(cannonCollision:ICollider, ballCollision:ICollider){        
        updateHealthValue();
        if(cannonHealth<=0){
            changeState(new EndGame(false));
        }        
    }

    function bulletVsBall(bulletCollision: ICollider, ballCollision:ICollider){
        var bullet:Bullet = cast bulletCollision.userData;
		bullet.die();
        var ball:Ball = cast ballCollision.userData;
        var newBallType = ball.getType() -1;   
        if(newBallType>0){
            addBall(ball.getX(),ball.getY(),newBallType, -1,new FastVector2(ball.getVelocity().x,ball.getVelocity().y));
            addBall(ball.getX(),ball.getY(),newBallType, 1,new FastVector2(ball.getVelocity().x,ball.getVelocity().y));
        }else{
            updateKillsValue();
        }     
        ball.die();             
    }

    #if DEBUGDRAW
	override function draw(framebuffer:Canvas) {
		super.draw(framebuffer);
		CollisionEngine.renderDebug(framebuffer,stage.defaultCamera());
	}
	#end
}