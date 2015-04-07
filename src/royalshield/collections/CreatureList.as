package royalshield.collections
{
    import flash.utils.Dictionary;
    
    import royalshield.entities.creatures.Creature;
    import royalshield.errors.NullArgumentError;
    
    public class CreatureList
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_creatures:Dictionary;
        private var m_ids:Vector.<uint>;
        private var m_length:uint;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get length():uint { return m_length; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function CreatureList()
        {
            m_creatures = new Dictionary();
            m_ids = new Vector.<uint>();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function push(creature:Creature):Creature
        {
            if (!creature)
                throw new NullArgumentError("creature");
            
            var key:uint = creature.id;
            m_creatures[key] = creature;
            m_ids[m_length] = key;
            m_length++;
            return creature;
        }
        
        public function unshift(creature:Creature):Creature
        {
            if (!creature)
                throw new NullArgumentError("creature");
            
            var key:uint = creature.id;
            m_creatures[key] = creature;
            m_ids.unshift(key);
            m_length++;
            return creature;
        }
        
        public function remove(creature:Creature):Creature
        {
            if (!creature)
                throw new NullArgumentError("creature");
            
            var key:uint = creature.id;
            if (m_creatures[key] === undefined)
                return null;
            
            delete m_creatures[key];
            
            for (var i:uint = 0; i < m_length; i++) {
                if (m_ids[i] == key)
                    break;
            }
            
            var len:uint = Math.max(0, m_length - 1);
            for (; i < len; i++)
                m_ids[i] = m_ids[i + 1];
            
            m_ids[len] = 0;
            m_length = len;
            return creature;
        }
        
        public function has(creature:Creature):Boolean
        {
            if (creature && m_creatures[creature.id] !== undefined)
                return true;
            
            return false;
        }
        
        public function getById(id:uint):Creature
        {
            if (m_creatures[id] !== undefined)
                return m_creatures[id];
            
            return null;
        }
        
        public function getAt(index:int):Creature
        {
            if (index >= 0 && index < m_length)
                return m_creatures[ m_ids[index] ];
            
            return null;
        }
        
        public function isEmpty():Boolean
        {
            return (m_length == 0);
        }
        
        public function clear():void
        {
            m_creatures = new Dictionary();
            m_ids.length = 0;
            m_length = 0;
        }
    }
}
