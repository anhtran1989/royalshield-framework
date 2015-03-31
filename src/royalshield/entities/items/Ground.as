package royalshield.entities.items
{
    public class Ground extends Item
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        protected var m_speed:uint;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get speed():uint { return m_speed; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Ground(id:uint, name:String, speed:uint)
        {
            super(id, name);
            
            m_speed = speed;
        }
    }
}
