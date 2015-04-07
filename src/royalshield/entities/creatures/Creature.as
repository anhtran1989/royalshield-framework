package royalshield.entities.creatures
{
    import royalshield.collections.CreatureList;
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
    import royalshield.utils.FindPathParams;
    import royalshield.utils.GameUtil;
    import royalshield.utils.IDestroyable;
    import royalshield.utils.MinMaxValues;
    import royalshield.utils.isNullOrEmpty;
    import royalshield.world.IWorldMap;
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
        
        // Summon
        protected var m_summons:CreatureList;
        protected var m_master:Creature;
        
        // Follow
        protected var m_followCreature:Creature;
        protected var m_hasFollowPath:Boolean;
        protected var m_forceUpdateFollowPath:Boolean;
        protected var m_isUpdatingPath:Boolean;
        
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
        private var m_directionList:Vector.<Direction>;
        private var m_direction:Direction;
        private var m_position:Position;
        
        private var m_cancelNextWalk:Boolean;
        private var m_walkEvent:Boolean;
        private var m_lastStepTime:int;
        
        private var m_walkCompletedSignal:Signal;
        
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
        
        public function get direction():Direction { return m_direction; }
        public function set direction(value:Direction):void
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
        
        public function get isSummon():Boolean { return (m_master != null); }
        public function get master():Creature { return m_master; }
        
        public function get onWalkCompleted():Signal { return m_walkCompletedSignal; }
        
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
            m_directionList = new Vector.<Direction>();
            m_direction = Direction.SOUTH;
            m_position = new Position();
            worldRemoved = true;
            
            m_walkCompletedSignal = new Signal();
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
        
        public function walkTo(direction:Direction):void
        {
            if (!this.canMove) {
                stopWalk();
                return;
            }
            
            m_directionList.length = 0;
            m_directionList[m_directionList.length] = direction;
            addEventWalk();
        }
        
        public function startAutoWalk(directions:Vector.<Direction>):Boolean
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
        
        public function getTimeSinceLastMove():int
        {
            if (m_lastStepTime != 0)
                return (m_elapsedTime - m_lastStepTime);
            
            return int.MAX_VALUE;
        }
        
        public function getCombatValues(mmv:MinMaxValues):MinMaxValues
        {
            return null;
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
        
        public function addSummon(creature:Creature):void
        {
            if (!m_summons)
                m_summons = new CreatureList();
            else if (m_summons.has(creature))
                return;
            
            creature.m_master = this;
            m_summons.push(creature);
        }
        
        public function removeSummon(creature:Creature):void
        {
            if (m_summons && m_summons.has(creature)) {
                m_summons.remove(creature);
                creature.m_master = null;
                
                if (m_summons.isEmpty())
                    m_summons = null;
            }
        }
        
        public function setFollowCreature(creature:Creature):Boolean
        {
            if (creature) {
                if (m_followCreature == creature)
                    return true;
                
                if (this.position.z != creature.position.z || !canSeePosition(creature.position)) {
                    m_followCreature = null;
                    return false;
                }
                
                if (m_directionList.length != 0) {
                    m_directionList.length = 0;
                    onWalkAborted();
                }
                
                m_hasFollowPath = false;
                m_forceUpdateFollowPath = false;
                m_followCreature = creature;
                m_isUpdatingPath = true;
            } else {
                m_isUpdatingPath = false;
                m_followCreature = null;
            }
            
            onFollowCreature(creature);
            return true;
        }
        
        public function goToFollowCreature():void
        {
            if (m_followCreature) {
                var fpp:FindPathParams = new FindPathParams();
                getPathSearchParams(m_followCreature, fpp);
                
                var map:IWorldMap = RoyalShield.getInstance().world.map;
                if(map.getPathMatching(this, m_directionList, m_followCreature.position, fpp)) {
                    m_hasFollowPath = true;
                    startAutoWalk(m_directionList);
                } else
                    m_hasFollowPath = false;
            }
            
            onFollowCreatureComplete(m_followCreature);
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
                m_outfit.render(canvas, pointX + m_outfit.offsetX, pointY + m_outfit.offsetY, direction.index, 0, 0);
        }
        
        public function destroy():void
        {
            if (m_summons)
                m_summons.clear();
            
            m_outfit = null;
            m_id = 0;
            m_summons = null;
            
            m_walkCompletedSignal.removeAll();
        }
        
        //--------------------------------------
        // Internal
        //--------------------------------------
        
        royalshield_internal function onWalk():void
        {
            if (getWalkDelay() <= 0) {
                var flags:uint = 0;
                var direction:Direction = getNextStep();
                
                if (direction != null) {
                    RoyalShield.getInstance().world.moveCreature(this, direction);
                } else {
                    if (m_directionList.length == 0)
                        m_walkCompletedSignal.dispatch();
                    
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
            if (creature == this)
                m_lastStepTime = m_elapsedTime;
        }
        
        royalshield_internal function onCreatureAppear(creature:Creature):void
        {
            ////
        }
        
        royalshield_internal function onCreatureDisappear(creature:Creature):void
        {
            ////
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
        
        protected function getStepDuration(direction:Direction = null):Number
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
        
        protected function getWalkDelay(direction:Direction = null):int
        {
            if (m_lastStepTime != 0)
                return getStepDuration(direction) - (m_elapsedTime - m_lastStepTime);
            
            return 0;
        }
        
        protected function getNextStep():Direction
        {
            if (m_directionList.length > 0)
                return m_directionList.shift();
            
            return null;
        }
        
        protected function getPathSearchParams(creature:Creature, fpp:FindPathParams):void
        {
            fpp.fullPathSearch = !m_hasFollowPath;
            fpp.clearSight = true;
            fpp.maxSearchDist = 12;
            fpp.minTargetDist = 1;
            fpp.maxTargetDist = 1;
        }
        
        protected function onWalkAborted():void
        {
            //
        }
        
        protected function onFollowCreature(creature:Creature):void
        {
            //
        }
        
        protected function onFollowCreatureComplete(creature:Creature):void
        {
            //
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static protected const SPEED_A:Number = 857.36;
        static protected const SPEED_B:Number = 261.29;
        static protected const SPEED_C:Number = -4795.01;
        
        static protected function canSee(x1:int, y1:int, x2:int, y2:int, deltaX:int, deltaY:int):Boolean
        {
            return (Math.abs(x1 - x2) < deltaX && Math.abs(y1 - y2) < deltaY);
        }
    }
}
