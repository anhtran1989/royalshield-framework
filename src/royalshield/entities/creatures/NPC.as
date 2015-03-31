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
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function NPC(id:uint, name:String)
        {
            super(id, name);
            
            m_walkTicks = 2000;
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
            if (creature) {
                m_creatureFocus = creature;
                turnToCreature(creature);
            } else
                m_creatureFocus = null;
        }
        
        //--------------------------------------
        // Override Internal
        //--------------------------------------
        
        override royalshield_internal function onCreatureMove(creature:Creature, newTile:Tile, oldTile:Tile, teleport:Boolean):void
        {
            if (creature == m_creatureFocus)
                turnToCreature(creature);
        }
    }
}
