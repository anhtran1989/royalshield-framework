package royalshield.entities.creatures
{
    import royalshield.signals.Signal;

    public class Player extends Creature
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_level:uint;
        private var m_levelPercent:uint;
        private var m_magicLevel:uint;
        private var m_magicLevelPercent:uint;
        private var m_experience:uint;
        
        private var m_levelChangedSignal:Signal;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get level():uint { return m_level; }
        public function set level(value:uint):void
        {
            if (m_level != value) {
                var oldValue:uint = m_level;
                m_level = value;
                m_levelChangedSignal.dispatch(oldValue, m_level);
                updateBaseSpeed();
            }
        }
        
        public function get levelPercent():uint { return m_levelPercent; }
        public function get magicLevel():uint { return m_magicLevel; }
        public function get magicLevelPercent():uint { return m_magicLevelPercent; }
        public function get experience():uint { return m_experience; }
        
        public function get onLevelChanged():Signal { return m_levelChangedSignal; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Player()
        {
            super();
            
            m_name = "Player";
            m_level = 1;
            
            m_levelChangedSignal = new Signal();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function updateBaseSpeed():void
        {
            m_baseSpeed = /*m_vocation.baseSpeed*/ 220 + (2 * (this.level - 1));
        }
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        override public function toString():String
        {
            return "[Player name=" + this.name + ", id=" + this.id + "]";
        }
        
        override public function destroy():void
        {
            super.destroy();
            m_levelChangedSignal.removeAll();
        }
    }
}
