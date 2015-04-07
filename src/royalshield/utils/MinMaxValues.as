package royalshield.utils
{
    public class MinMaxValues
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var min:int;
        public var max:int;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MinMaxValues(min:int = 0, max:int = 0)
        {
            this.min = min;
            this.max = max;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function setTo(min:int = 0, max:int = 0):MinMaxValues
        {
            this.min = min;
            this.max = max;
            return this;
        }
        
        public function setZero():MinMaxValues
        {
            min = 0;
            max = 0;
            return this;
        }
    }
}
