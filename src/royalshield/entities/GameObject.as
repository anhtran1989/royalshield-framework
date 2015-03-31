package royalshield.entities
{
    /**
     * This is the base class for all map objects.
     */
    public class GameObject implements IGameObject
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        protected var m_id:uint;
        protected var m_name:String;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get id():uint { return m_id; }
        public function get name():String { return m_name; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function GameObject(id:uint = 0, name:String = null)
        {
            m_id = id;
            m_name = name;
        }
    }
}
