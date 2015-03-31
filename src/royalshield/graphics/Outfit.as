package royalshield.graphics
{
    public class Outfit extends Graphic
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_animateAlways:Boolean;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get animateAlways():Boolean { return m_animateAlways; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Outfit(type:GraphicType)
        {
            super(type);
        }
    }
}
