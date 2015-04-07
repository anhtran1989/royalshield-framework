package royalshield.signals
{
    import flash.utils.Dictionary;
    
    public class Signal
    {
        // --------------------------------------------------------------------------
        // PROPERTIES
        // --------------------------------------------------------------------------
        
        private var m_callbacks:Dictionary;
        private var m_length:uint;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get length():uint { return m_length; }
        
        // --------------------------------------------------------------------------
        // CONSTRUCTOR
        // --------------------------------------------------------------------------
        
        public function Signal()
        {
            m_callbacks = new Dictionary(true);
        }
        
        // --------------------------------------------------------------------------
        // METHODS
        // --------------------------------------------------------------------------
        
        // --------------------------------------
        // Public
        // --------------------------------------
        
        public function add(callback:Function):Boolean
        {
            if (!has(callback)) {
                m_callbacks[callback] = new Slot(callback);
                m_length++;
                return true;
            }
            return false;
        }
        
        public function addOnce(callback:Function):Boolean
        {
            if (!has(callback)) {
                m_callbacks[callback] = new Slot(callback, true);
                m_length++;
                return true;
            }
            return false;
        }
        
        public function has(callback:Function):Boolean
        {
            return (callback != null && m_callbacks[callback] !== undefined);
        }
        
        public function remove(callback:Function):Boolean
        {
            if (has(callback)) {
                delete m_callbacks[callback];
                m_length = Math.max(0, m_length - 1);
            }
            return false;
        }
        
        public function removeAll():Boolean
        {
            m_callbacks = new Dictionary();
            m_length = 0;
            return true;
        }
        
        public function dispatch(...args):void
        {
            for each (var slot:Slot in m_callbacks) {
                slot.callback.apply(null, args);
                if (slot.once)
                    delete m_callbacks[slot.callback];
            }
        }
    }
}

// ******************************************************************************
// HELPER CLASS
// ******************************************************************************

class Slot
{
    // --------------------------------------------------------------------------
    // PROPERTIES
    // --------------------------------------------------------------------------
    
    public var callback:Function;
    public var once:Boolean;
    
    // --------------------------------------------------------------------------
    // CONSTRUCTOR
    // --------------------------------------------------------------------------
    
    public function Slot(callback:Function, once:Boolean = false)
    {
        this.callback = callback;
        this.once = once;
    }
}
