package royalshield.animators.utils
{
    public class FrameDuration
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_minimum:uint;
        private var m_maximum:uint;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get minimum():uint { return m_minimum; }
        public function get maximum():uint { return m_maximum; }
        public function get duration():uint
        {
            if (m_minimum == m_maximum)
                return m_minimum;
            
            return m_minimum + Math.round(Math.random() * (m_maximum - m_minimum));
        }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function FrameDuration(minimum:uint = 0, maximum:uint = 0)
        {
            setTo(minimum, maximum);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function toString():String
        {
            return "[FrameDuration minimum=" + m_minimum + ", maximum=" + m_maximum + "]";
        }
        
        public function setTo(minimum:uint, maximum:uint):void
        {
            if (minimum > maximum)
                throw new ArgumentError("The minimum value may not be greater than the maximum value.");
            
            m_minimum = minimum;
            m_maximum = maximum;
        }
        
        public function clone():FrameDuration
        {
            return new FrameDuration(m_minimum, m_maximum);
        }
    }
}
