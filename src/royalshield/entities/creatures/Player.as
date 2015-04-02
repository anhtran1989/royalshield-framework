package royalshield.entities.creatures
{
    public class Player extends Creature
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Player()
        {
            super();
            
            m_name = "Player";
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        override public function toString():String
        {
            return "[Player name=" + this.name + ", id=" + this.id + "]";
        }
    }
}
