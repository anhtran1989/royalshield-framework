package royalshield.signals
{
    import royalshield.errors.NullArgumentError;
    
    public class Signal
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_callbacks:Vector.<Function>;
        private var m_length:uint;
        private var m_index:int;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get length():uint { return m_length; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Signal()
        {
            
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function add(callback:Function):Boolean
        {
            if (callback == null)
                throw new NullArgumentError("callback");
            
            if (!m_callbacks)
                m_callbacks = new Vector.<Function>();
            
            if (m_callbacks.indexOf(callback) != -1)
                return false;
            
            m_callbacks[m_length++] = callback;
            return true;
        }
        
        public function has(callback:Function):Boolean
        {
            if (m_callbacks && callback != null)
                return (m_callbacks.indexOf(callback) != -1)
                
            return false;
        }
        
        public function remove(callback:Function):Boolean
        {
            if (m_callbacks && callback != null) {
                m_index = m_callbacks.indexOf(callback);
                if (m_index > -1) {
                    m_callbacks.splice(m_index, 1);
                    m_length = m_callbacks.length;
                    return true;
                }
            }
            return false;
        }
        
        public function removeAll():Boolean
        {
            m_callbacks = null;
            return true;
        }
        
        public function dispatch(...args):void
        {
            for (m_index = 0; m_index < m_length; m_index++)
                m_callbacks[m_index].apply(null, args);
        }
    }
}
