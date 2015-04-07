package royalshield.world
{
    import royalshield.collections.IItemContainer;
    import royalshield.core.royalshield_internal;
    import royalshield.entities.GameObject;
    import royalshield.entities.creatures.Creature;
    import royalshield.entities.items.Ground;
    import royalshield.entities.items.Item;
    import royalshield.graphics.Effect;
    
    use namespace royalshield_internal;
    
    public class Tile implements IItemContainer
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_x:uint;
        private var m_y:uint;
        private var m_z:uint;
        private var m_flags:uint;
        private var m_ground:Ground;
        private var m_items:Vector.<Item>;
        private var m_itemCount:uint;
        private var m_firstCreature:Creature;
        private var m_lastCreature:Creature;
        private var m_creaturesCount:uint;
        private var m_firstEffect:Effect;
        private var m_lastEffect:Effect;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get x():uint { return m_x; }
        public function get y():uint { return m_y; }
        public function get z():uint { return m_z; }
        public function get flags():uint { return m_flags; }
        public function get ground():Ground { return m_ground; }
        public function get itemCount():uint { return m_itemCount; }
        public function get firstCreature():Creature { return m_firstCreature; }
        public function get lastCreature():Creature { return m_lastCreature; }
        public function get creatureCount():uint { return m_creaturesCount; }
        public function get firstEffect():Effect { return m_firstEffect; }
        public function get lastEffect():Effect { return m_lastEffect; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Tile(x:uint, y:uint, z:uint, flags:uint = 0)
        {
            m_x = x;
            m_y = y;
            m_z = z;
            m_flags = flags;
            m_itemCount = 0;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function toString():String
        {
            return "[Tile x=" + this.x + ", y=" + this.y + ", z=" + this.z + "]";
        }
        
        public function queryAdd(thing:GameObject):Boolean
        {
            if (thing is Creature) {
                if (hasFlag(TileFlags.SOLID) || m_firstCreature)
                    return false;
            }
            return true;
        }
        
        public function addItem(item:Item):Boolean
        {
            if (!item)
                return false;
            
            if (item is Ground) {
                if (m_ground) {
                    m_ground = null;
                    m_itemCount--;
                }
                
                m_ground = Ground(item);
                m_itemCount++;
            } else {
                if (!m_items)
                    m_items = new Vector.<Item>();
                
                m_items[m_items.length] = item;
                m_itemCount++;
            }
            
            return true;
        }
        
        public function removeItem(item:Item):Boolean
        {
            if (!item || m_itemCount == 0)
                return false;
            
            if (item == ground) {
                m_ground = null;
                m_itemCount--;
            } else if (m_items) {
                var index:int = m_items.indexOf(item);
                if (index == -1) return false;
                
                m_items.splice(index, 1);
                m_itemCount--;
                
                if (m_items.length == 0)
                    m_items = null;
            }
            
            return true;
        }
        
        public function getItemAt(index:int):Item
        {
            if (m_ground) {
                if (index == 0)
                    return m_ground;
                
                index--;
            }
            
            if (m_items && index < m_items.length)
                return m_items[index];
            
            return null;
        }
        
        public function addCreature(creature:Creature):Boolean
        {
            if (!creature)
                return false;
            
            if (!m_lastCreature) {
                m_firstCreature = creature;
                m_lastCreature = creature;
            } else {
                m_lastCreature.next = creature;
                creature.prev = m_lastCreature;
                m_lastCreature = creature;
            }
            
            m_creaturesCount++;
            creature.containerParent = this;
            creature.position.setTo(m_x, m_y, m_z);
            return true;
        }
        
        public function removeCreature(creature:Creature):Boolean
        {
            if (!creature)
                return false;
            
            if (creature.prev)
                creature.prev.next = creature.next;
            
            if (creature.next)
                creature.next.prev = creature.prev;
            
            if (creature == m_firstCreature)
                m_firstCreature = creature.next;
            
            if (creature == m_lastCreature)
                m_lastCreature = creature.prev;
            
            m_creaturesCount = Math.max(0, m_creaturesCount - 1);
            
            creature.next = null;
            creature.prev = null;
            creature.containerParent = null;
            creature.position.setEmpty();
            return true;
        }
        
        public function addEffect(effect:Effect):Boolean
        {
            if (effect.tile)
                return false;
            
            if (!m_lastEffect) {
                m_firstEffect = effect;
                m_lastEffect  = effect;
            } else {
                m_lastEffect.next = effect;
                effect.prev = m_lastEffect;
                m_lastEffect = effect;
            }
            
            effect.tile = this;
            return true;
        }
        
        public function removeEffect(effect:Effect):Boolean
        {
            if (!effect.tile || effect.tile != this)
                return false;
            
            if (effect == m_firstEffect)
                m_firstEffect = effect.next;
            
            if (effect == m_lastEffect)
                m_lastEffect = effect.prev;
            
            effect.tile = null;
            return true;
        }
        
        //--------------------------------------
        // Internal
        //--------------------------------------
        
        royalshield_internal function setFlag(flag:uint):void
        {
            m_flags = (m_flags | flag);
        }
        
        royalshield_internal function hasFlag(flag:uint):Boolean
        {
            return ((m_flags & flag) == flag);
        }
        
        royalshield_internal function resetFlag(flag:uint):void
        {
            m_flags = (m_flags & ~flag);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const MAX_ITEMS:uint = 10;
        static public const MAX_CREATURES:uint = 10;
    }
}
