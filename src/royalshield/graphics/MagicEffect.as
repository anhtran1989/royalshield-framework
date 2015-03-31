package royalshield.graphics
{
    public class MagicEffect extends Effect
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MagicEffect(type:GraphicType)
        {
            super(type);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        override public function update(elapsed:Number):Boolean
        {
            super.update(elapsed);
            return m_animator ? m_animator.isComplete : true;
        }
    }
}
