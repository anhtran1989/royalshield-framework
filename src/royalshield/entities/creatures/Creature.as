package royalshield.entities.creatures
{
    import royalshield.collections.IGameObjectContainer;
    import royalshield.core.GameConsts;
    import royalshield.core.RoyalShield;
    import royalshield.core.royalshield_internal;
    import royalshield.display.GameCanvas;
    import royalshield.entities.GameObject;
    import royalshield.entities.IDynamicGameObject;
    import royalshield.geom.Direction;
    import royalshield.geom.Position;
    import royalshield.graphics.IRenderable;
    import royalshield.graphics.IUpdatable;
    import royalshield.graphics.Outfit;
    import royalshield.signals.Signal;
    import royalshield.utils.GameUtil;
    import royalshield.utils.IDestroyable;
    import royalshield.utils.isNullOrEmpty;
    import royalshield.world.Tile;
    import royalshield.world.WorldMap;
    
    use namespace royalshield_internal;
    
    public class Creature extends GameObject implements IDynamicGameObject, IUpdatable, IRenderable, IDestroyable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        royalshield_internal var prev:Creature;
        royalshield_internal var next:Creature;
        royalshield_internal var checkerIndex:int = -1;
        royalshield_internal var containerParent:Tile;
        royalshield_internal var worldRemoved:Boolean;
        
        protected var m_healthMax:int;
        protected var m_health:int;
        protected var m_heathPercent:uint;
        protected var m_baseSpeed:int;
        protected var m_variableSpeed:int;
        
        private var m_outfit:Outfit;
        private var m_walkOffsetX:int;
        private var m_walkOffsetY:int;
        private var m_outfitOffsetX:int;
        private var m_outfitOffsetY:int;
        private var m_walkSpeedX:int;
        private var m_walkSpeedY:int;
        private var m_walkDuration:Number;
        private var m_walking:Boolean;
        private var m_animationEnd:Number;
        private var m_movementEnd:Number;
        private var m_elapsedTime:Number;
        private var m_directionList:Vector.<String>;
        private var m_direction:String;
        private var m_position:Position;
        
        private var m_cancelNextWalk:Boolean;
        private var m_walkEvent:Boolean;
        private var m_lastStepTime:int;
        
        private var m_onWalkCompleteSignal:Signal;
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        public function get healthMax():int { return m_healthMax; }
        public function get health():int { return m_health; }
        public function get healthPercent():uint { return m_heathPercent; }
        
        public function get speed():uint { return (m_baseSpeed + m_variableSpeed); }
        public function set speed(value:uint):void
        {
            var oldSpeed:uint = this.speed;
            m_variableSpeed = value;
            
            if (this.speed <= 0)
                stopEventWalk();
            else if (oldSpeed <= 0 && m_directionList.length == 0)
                addEventWalk();
        }
        
        public function get outfit():Outfit { return m_outfit; }
        public function set outfit(value:Outfit):void { m_outfit = value; }
        
        public function get walkOffsetX():int { return m_walkOffsetX; }
        public function get walkOffsetY():int { return m_walkOffsetY; }
        
        public function get outfitOffsetX():int { return m_outfitOffsetX; }
        public function get outfitOffsetY():int { return m_outfitOffsetY; }
        
        public function get walking():Boolean { return m_walking; }
        
        public function get direction():String { return m_direction; }
        public function set direction(value:String):void
        {
            if (isNullOrEmpty(value))
                value = Direction.NORTH;
            
            if (value != m_direction &&
                (value == Direction.NORTH ||
                value == Direction.EAST ||
                value == Direction.SOUTH ||
                value == Direction.WEST))
            {
                m_direction = value;
            }
        }
        
        public function get canMove():Boolean { return true; }
        public function get parent():IGameObjectContainer { return containerParent; }
        public function get topParent():IGameObjectContainer { return containerParent; }
        public function get isWorldRemoved():Boolean { return worldRemoved; }
        public function get tile():Tile { return containerParent; }
        public function get position():Position { return m_position; }
        
        public function get onWalkComplete():Signal { return m_onWalkCompleteSignal; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Creature()
        {
            super();
            
            m_name = "Creature";
            m_healthMax = 100;
            m_health = m_healthMax;
            m_heathPercent = GameUtil.getPercentValue(m_health, m_healthMax);
            m_baseSpeed = 200;
            m_variableSpeed = 0;
            m_walkDuration = 0;
            m_animationEnd = 0;
            m_movementEnd = 0;
            m_elapsedTime = 0;
            m_directionList = new Vector.<String>();
            m_direction = Direction.SOUTH;
            m_position = new Position();
            worldRemoved = true;
            
            m_onWalkCompleteSignal = new Signal();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function toString():String
        {
            return "[Creature name=" + this.name + "]";
        }
        
        public function startWalk(x:int, y:int):void
        {
            if (x > 0)
                m_direction = Direction.EAST;
            else if (x < 0)
                m_direction = Direction.WEST;
            else if (y < 0)
                m_direction = Direction.NORTH;
            else if (y > 0)
                m_direction = Direction.SOUTH;
            
            var tileSize:uint = GameConsts.VIEWPORT_TILE_SIZE;
            var duration:Number = getStepDuration(m_direction);
            
            m_walkOffsetX = -x * tileSize;
            m_walkOffsetY = -y * tileSize;
            m_walkSpeedX = m_walkOffsetX;
            m_walkSpeedY = m_walkOffsetY;
            m_walkDuration = duration;
            m_animationEnd = m_elapsedTime + duration;
            
            if (Math.abs(x) + Math.abs(y) > 1)
                duration *= 3;
            
            m_movementEnd = m_elapsedTime + duration;
            m_walking = true;
        }
        
        public function walkTo(direction:String):void
        {
            if (!this.canMove) {
                stopWalk();
                return;
            }
            
            m_directionList.length = 0;
            m_directionList[m_directionList.length] = direction;
            addEventWalk();
        }
        
        public function startAutoWalk(directions:Vector.<String>, completeHandler:Function = null):Boolean
        {
            if (isNullOrEmpty(directions))
                return false;
            
            if (this is Player && !Player(this).canMove) {
                stopWalk();
                return false;
            }
            
            if (directions != m_directionList) {
                m_directionList.length = 0;
                
                var length:uint = directions.length;
                for (var i:uint = 0; i < length; i++)
                    m_directionList[i] = directions[i];
            }
            
            addEventWalk();
            return true;
        }
        
        public function stopWalk():void
        {
            m_walkOffsetX = 0;
            m_walkOffsetY = 0;
            m_walkSpeedX = 0;
            m_walkSpeedY = 0;
            m_walkDuration = 0;
            m_animationEnd = 0;
            m_movementEnd = 0;
            m_walking = false;
            m_cancelNextWalk = false;
            m_directionList.length = 0;
        }
        
        /**
         * Increases/decreases a value to the current health.
         * 
         * @param value The amount of health to be changed.
         */
        public function changeHealth(value:int):void
        {
            m_health = Math.max(0, Math.min(m_healthMax, m_health + value));
            m_heathPercent = GameUtil.getPercentValue(m_health, m_healthMax);
        }
        
        public function canSeePosition(position:Position):Boolean
        {
            return canSee(m_position.x, m_position.y, position.x, position.y, WorldMap.MAX_VIEWPORT_X, WorldMap.MAX_VIEWPORT_Y);
        }
        
        protected function canSeeCreature(creature:Creature):Boolean
        {
            return canSeePosition(creature.position);
        }
        
        public function onThink(interval:uint):void
        {
            //trace(interval);
        }
        
        public function onDeath():void
        {
            //
        }
        
        public function update(elapsedTime:Number):Boolean
        {
            if (isWorldRemoved)
                return false;
            
            m_elapsedTime = elapsedTime;
            
            // Movement
            if (m_walking) {
                var time:Number = elapsedTime - (m_animationEnd - m_walkDuration);
                if (time <= 0) {
                    m_walkOffsetX = m_walkSpeedX;
                    m_walkOffsetY = m_walkSpeedY;
                } else if (time >= m_walkDuration) {
                    m_walkOffsetX = 0;
                    m_walkOffsetY = 0;
                } else if (m_walkDuration != 0) {
                    m_walkOffsetX = m_walkSpeedX - Math.round(m_walkSpeedX / m_walkDuration * time);
                    m_walkOffsetY = m_walkSpeedY - Math.round(m_walkSpeedY / m_walkDuration * time);
                }
            }
            m_walking = (elapsedTime < m_movementEnd || m_walkOffsetX != 0 || m_walkOffsetY != 0);
            
            var frames:int;
            var delta:int;
            
            if (m_outfit) {
                if (m_outfit.animateAlways)
                    m_outfit.update(elapsedTime);
                else if (!m_walking || elapsedTime > m_animationEnd)
                    m_outfit.frame = 0;
                else {
                    frames = m_outfit.frames;
                    delta = Math.max(Math.abs(m_walkOffsetX), Math.abs(m_walkOffsetY));
                    m_outfit.frame = 1 + delta * 4 / GameConsts.VIEWPORT_TILE_SIZE % (frames - 1);
                }
            }
            
            if (m_walkEvent && !m_walking)
                RoyalShield.getInstance().world.checkCreatureWalk(this);
            
            return true;
        }
        
        public function render(canvas:GameCanvas, pointX:int, pointY:int, patternX:int = 0, patternY:int = 0, patternZ:int = 0):void
        {
            if (m_outfit)
                m_outfit.render(canvas, pointX + m_outfit.offsetX, pointY + m_outfit.offsetY, Direction.toValue(direction), 0, 0);
        }
        
        public function destroy():void
        {
            m_outfit = null;
            m_id = 0;
        }
        
        //--------------------------------------
        // Internal
        //--------------------------------------
        
        royalshield_internal function onWalk():void
        {
            if (getWalkDelay() <= 0) {
                var flags:uint = 0;
                var direction:String = getNextStep();
                
                if (direction != null) {
                    RoyalShield.getInstance().world.moveCreature(this, direction);
                } else {
                    if (m_directionList.length == 0)
                        m_onWalkCompleteSignal.dispatch();
                    
                    stopEventWalk();
                }
            }
            
            if (m_cancelNextWalk) {
                m_cancelNextWalk = false;
                m_walkEvent = false;
                m_directionList.length = 0;
                onWalkAborted();
            }
            
            if (m_walkEvent) {
                m_walkEvent = false;
                addEventWalk();
            }
        }
        
        royalshield_internal function onCreatureMove(creature:Creature, newTile:Tile, oldTile:Tile, teleport:Boolean):void
        {
            //
        }
        
        royalshield_internal function setUniqueId(id:uint):void
        {
            m_id = id;
        }
        
        //--------------------------------------
        // Protected
        //--------------------------------------
        
        protected function addEventWalk():void
        {
            m_cancelNextWalk = false;
            
            if (this.speed > 0)
                m_walkEvent = true;
        }
        
        protected function stopEventWalk():void
        {
            m_cancelNextWalk = true;
        }
        
        protected function getStepDuration(direction:String = null):Number
        {
            if (isWorldRemoved)
                return 0;
            
            var calculated:int;
            var stepSpeed:int = this.speed;
            if (stepSpeed > -SPEED_B) {
                calculated = Math.floor((SPEED_A * Math.log((stepSpeed / 2) + SPEED_B) + SPEED_C) + 0.5);
                
                if (calculated <= 0)
                    calculated = 1;
            }
            else
                calculated = 1;
            
            var groundSpeed:uint = (containerParent && containerParent.ground) ? containerParent.ground.speed : 0;
            groundSpeed = groundSpeed == 0 ? 150 : groundSpeed;
            var duration:Number = Math.floor(1000 * groundSpeed / calculated);
            var stepDuration:Number = Math.ceil(duration / 50) * 50;
            
            if (direction != null &&
                (direction == Direction.NORTHEAST ||
                 direction == Direction.NORTHWEST ||
                 direction == Direction.SOUTHEAST ||
                 direction == Direction.SOUTHWEST)) {
                stepDuration *= 3
            }
            return stepDuration;
        }
        
        protected function getWalkDelay(direction:String = null):int
        {
            if (m_lastStepTime != 0)
                return getStepDuration(direction) - (m_elapsedTime - m_lastStepTime);
            
            return 0;
        }
        
        protected function getNextStep():String
        {
            if (m_directionList.length > 0)
                return m_directionList.shift();
            
            return null;
        }
        
        protected function onWalkAborted():void
        {
            
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        protected static const SPEED_A:Number = 857.36;
        protected static const SPEED_B:Number = 261.29;
        protected static const SPEED_C:Number = -4795.01;
        
        protected static function canSee(x1:int, y1:int, x2:int, y2:int, deltaX:int, deltaY:int):Boolean
        {
            return (Math.abs(x1 - x2) < deltaX && Math.abs(y1 - y2) < deltaY);
        }
    }
}
