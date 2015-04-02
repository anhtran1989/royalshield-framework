package royalshield.entities.creatures
{
    import royalshield.core.RoyalShield;
    import royalshield.core.royalshield_internal;
    import royalshield.geom.Direction;
    import royalshield.world.Tile;
    
    use namespace royalshield_internal;
    
    public class NPC extends Creature
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_creatureFocus:Creature;
        private var m_walkTicks:uint;
        private var m_isIdle:Boolean;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function NPC(name:String)
        {
            super();
            
            m_name = name;
            m_baseSpeed = 80;
            m_walkTicks = 5000;
            m_isIdle = true;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function turnToCreature(creature:Creature):void
        {
            if (worldRemoved)
                return;
            
            var dx:int = this.tile.x - creature.tile.x;
            var dy:int = this.tile.y - creature.tile.y;
            
            var tan:Number = 0;
            if(dx != 0)
                tan = dy / dx;
            else
                tan = 10;
            
            var direction:String = Direction.SOUTH;
            if(Math.abs(tan) < 1) {
                if(dx > 0)
                    direction = Direction.WEST;
                else
                    direction = Direction.EAST;
            } else {
                if(dy > 0)
                    direction = Direction.NORTH;
                else
                    direction = Direction.SOUTH;
            }
            
            RoyalShield.getInstance().world.creatureTurn(this.id, direction);
        }
        
        public function setCreatureFocus(creature:Creature):void
        {
            if (creature)
                turnToCreature(creature);
            
            m_creatureFocus = creature;
        }
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        override public function toString():String
        {
            return "[NPC name=" + this.name + ", id=" + this.id + "]";
        }
        
        //--------------------------------------
        // Protected
        //--------------------------------------
        
        protected function canWalkTo(direction:String):Boolean
        {
            return true;
        }
        
        protected function getRandomStep():String
        {
            var dir:String = Direction.valueToDirection(Math.random() * 4);
            if (canWalkTo(dir))
                return dir;
            
            return null;
        }
        
        //--------------------------------------
        // Override Protected
        //--------------------------------------
        
        override public function onThink(interval:uint):void
        {
            super.onThink(interval);
            
            if (getTimeSinceLastMove() >= m_walkTicks)
                addEventWalk();
            
            if (!m_isIdle)
                setCreatureFocus(null);
        }
        
        override protected function getNextStep():String
        {
            var direction:String = super.getNextStep();
            if (direction != null)
                return direction;
            
            if (m_isIdle || m_walkTicks == 0 || getTimeSinceLastMove() <= m_walkTicks)
                return null;
            
            return getRandomStep();
        }
        
        //--------------------------------------
        // Override Internal
        //--------------------------------------
        
        override royalshield_internal function onCreatureMove(creature:Creature, newTile:Tile, oldTile:Tile, teleport:Boolean):void
        {
            if (creature is Player)
                m_isIdle = false;
        }
    }
}
