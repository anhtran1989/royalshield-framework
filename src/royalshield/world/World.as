package royalshield.world
{
    import flash.utils.Dictionary;
    
    import royalshield.core.GameConsts;
    import royalshield.core.royalshield_internal;
    import royalshield.entities.creatures.Creature;
    import royalshield.entities.items.Item;
    import royalshield.errors.NullArgumentError;
    import royalshield.geom.Direction;
    import royalshield.graphics.Effect;
    import royalshield.graphics.IUpdatable;
    import royalshield.signals.Signal;
    import royalshield.utils.CreatureChecker;
    import royalshield.utils.GameUtil;
    import royalshield.utils.ThingUpdater;
    
    use namespace royalshield_internal;
    
    public class World implements IUpdatable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_map:WorldMap;
        private var m_creatures:Dictionary;
        private var m_creatureCount:uint;
        private var m_thingUpdater:ThingUpdater;
        private var m_creatureChecker:CreatureChecker;
        private var m_effectList:Vector.<Effect>;
        private var m_toRemoveEffects:Vector.<Effect>;
        private var m_effectCount:uint;
        private var m_nextUpdateTime:Number;
        private var m_creatureAddedSignal:Signal;
        private var m_creatureRemovedSignal:Signal;
        private var m_creatureMovedSignal:Signal;
        private var m_creatureTurnedSignal:Signal;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get map():WorldMap { return m_map; }
        public function get creatureCount():uint { return m_creatureCount; }
        public function get onCreatureAdded():Signal { return m_creatureAddedSignal; }
        public function get onCreatureRemoved():Signal { return m_creatureRemovedSignal; }
        public function get onCreatureMoved():Signal { return m_creatureMovedSignal; }
        public function get onCreatureTurned():Signal { return m_creatureTurnedSignal; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function World()
        {
            m_map = new WorldMap();
            m_creatures = new Dictionary();
            m_thingUpdater = new ThingUpdater();
            m_creatureChecker = new CreatureChecker();
            m_effectList = new Vector.<Effect>(GameConsts.WORLD_MAX_EFFECTS, true);
            m_toRemoveEffects = new Vector.<Effect>();
            m_nextUpdateTime = 0;
            m_creatureAddedSignal = new Signal();
            m_creatureRemovedSignal = new Signal();
            m_creatureMovedSignal = new Signal();
            m_creatureTurnedSignal = new Signal();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function update(elapsedTime:Number):Boolean
        {
            m_thingUpdater.update(elapsedTime);
            m_creatureChecker.update(elapsedTime);
            
            var i:uint;
            
            if (elapsedTime > m_nextUpdateTime) {
                for (i = 0; i < m_effectCount; i++) {
                    var effect:Effect = m_effectList[i];
                    if (effect) {
                        if (effect.update(elapsedTime))
                            m_toRemoveEffects[m_toRemoveEffects.length] = effect;
                    }
                }
                
                var length:uint = m_toRemoveEffects.length;
                if (length > 0) {
                    for (i = 0; i < length; i++)
                        removeEffect(m_toRemoveEffects[i]); 
                    
                    m_toRemoveEffects.length = 0;
                }
                m_nextUpdateTime = elapsedTime + GameConsts.WORLD_UPDATE_INTERVAL;
            }
            return true;
        }
        
        public function addItem(item:Item, x:uint, y:uint, z:uint):Boolean
        {
            if (!item)
                throw new NullArgumentError("item");
            
            var tile:Tile = m_map.getTile(x, y, z);
            if (!tile || !tile.addItem(item))
                return false;
            
            if (item.isAnimated)
                m_thingUpdater.addGameObject(item);
            
            updateTileFlags(item, tile);
            return true;
        }
        
        public function removeItem(item:Item, tile:Tile):Boolean
        {
            if (!item)
                throw new NullArgumentError("item");
            
            if (!tile)
                throw new NullArgumentError("tile");
            
            if (!tile.removeItem(item))
                return false;
            
            if (tile.itemCount == 0)
                m_map.deleteTile(tile);
            
            if (item.isAnimated)
                m_thingUpdater.removeGameObject(item);
            
            updateTileFlags(item, tile, true);
            return true;
        }
        
        public function addCreature(creature:Creature, x:uint, y:uint, z:uint):Boolean
        {
            if (!creature)
                throw new NullArgumentError("creature");
            
            if (!creature.worldRemoved)
                return true;
            
            var tile:Tile = m_map.getTile(x, y, z);
            if (!tile || !tile.addCreature(creature))
                return false;
            
            creature.worldRemoved = false;
            creature.setUniqueId(uint(Math.random() * 0xFFFFFF) + 1);
            m_creatures[creature.id] = creature;
            m_creatureCount++;
            m_thingUpdater.addGameObject(creature);
            m_creatureChecker.addCreature(creature);
            m_creatureAddedSignal.dispatch(creature);
            return true;
        }
        
        public function removeCreature(creatureId:uint):Boolean
        {
            var creature:Creature = getCreatureById(creatureId);
            if (!creature || creature.isWorldRemoved || (creature.tile && !creature.tile.removeCreature(creature)))
                return false;
            
            creature.worldRemoved = true;
            delete m_creatures[creature.id];
            m_creatureCount = Math.max(0, m_creatureCount - 1);
            m_thingUpdater.removeGameObject(creature);
            m_creatureChecker.removeCreature(creature);
            m_creatureRemovedSignal.dispatch(creature);
            return true;
        }
        
        public function addEffect(effect:Effect, x:uint, y:uint, z:uint):Boolean
        {
            if (!effect)
                throw new NullArgumentError("effect");
            
            if (effect.mapIndex != -1 || (m_effectCount + 1) >= GameConsts.WORLD_MAX_EFFECTS)
                return false;
            
            var index:int = m_map.getTileIndex(x, y, z);
            var tile:Tile = m_map.getTileByIndex(index);
            
            if (!tile)
                return false;
            
            if (!tile.addEffect(effect))
                return false;
            
            effect.mapIndex = index;
            m_effectList[m_effectCount++] = effect;
            return true;
        }
        
        public function removeEffect(effect:Effect):Boolean
        {
            if (!effect)
                return false;
            
            // Verifica se o efeito já está adicionado ao mapa.
            var index:int = effect.mapIndex;
            if (index == -1)
                return true;
            
            // Remove o efeito do tile.
            var tile:Tile = m_map.getTileByIndex(index);
            if (!tile || !tile.removeEffect(effect))
                return false;
            
            // Remove o efeito da lista.
            index = m_effectList.indexOf(effect);
            if (index < 0)
                return false;
            
            m_effectList[index] = null;
            
            // Atualiza a quantidade de efeitos adicionados
            m_effectCount = Math.max(0, m_effectCount - 1);
            
            // Organiza os efeitos na lista
            while (index < m_effectCount) {
                m_effectList[index] = m_effectList[(index + 1)];
                index++;
            }
            
            m_effectList[m_effectCount] = null;
            effect.destroy();
            return true;
        }
        
        public function checkCreatureWalk(creature:Creature):void
        {
            creature.onWalk();
        }
        
        public function moveCreature(creature:Creature, direction:Direction):Boolean
        {
            var fromTile:Tile = creature.tile;
            var oldx:int = fromTile.x;
            var oldy:int = fromTile.y;
            var oldz:int = fromTile.z;
            var newx:int = oldx;
            var newy:int = oldy;
            var newz:int = oldz;
            var diagonal:Boolean = false;
            
            switch (direction)
            {
                case Direction.NORTH:
                    newy--;
                    break;
                
                case Direction.EAST:
                    newx++;
                    break;
                
                case Direction.SOUTH:
                    newy++
                    break;
                    
                case Direction.WEST:
                    newx--;
                    break;
                
                case Direction.NORTHEAST:
                    newx++;
                    newy--;
                    diagonal = true;
                    break;
                
                case Direction.SOUTHEAST:
                    newx++;
                    newy++;
                    diagonal = true;
                    break;
                
                case Direction.SOUTHWEST:
                    newx--;
                    newy++;
                    diagonal = true;
                    break;
                
                case Direction.NORTHWEST:
                    newx--;
                    newy--;
                    diagonal = true;
                    break;
            }
            
            var toTile:Tile = m_map.getTile(newx, newy, newz);
            if (!toTile || !toTile.ground)
                return false;
            
            if (!m_map.moveCreature(creature, toTile))
                return false;
            
            creature.startWalk(newx - oldx, newy - oldy);
            creature.direction = direction;
            
            var spectatores:Vector.<Creature> = GameUtil.CREATURE_VECTOR;
            spectatores.length = 0;
            m_map.getSpectators(oldx, oldy, oldz, spectatores, true);
            m_map.getSpectators(newx, newy, newz, spectatores, true);
            
            for (var i:uint = 0; i < spectatores.length; i++)
                spectatores[i].onCreatureMove(creature, fromTile, toTile, false);
            
            m_creatureMovedSignal.dispatch(creature);
            return true;
        }
        
        public function creatureTurn(creatureId:uint, direction:Direction):Boolean
        {
            var creature:Creature = getCreatureById(creatureId);
            if (creature && creature.direction != direction) {
                var oldDirection:Direction = creature.direction;
                creature.direction = direction;
                m_creatureTurnedSignal.dispatch(creature, oldDirection, direction);
            }
            return false;
        }
        
        public function getCreatureById(creatureId:uint):Creature
        {
            if (creatureId != 0 && m_creatures[creatureId] !== undefined)
                return m_creatures[creatureId];
            
            return null;
        }
        
        public function getCreatureByName(name:String):Creature
        {
            return null;
        }
        
        public function clear():void
        {
            for each(var creature:Creature in m_creatures)
                removeCreature(creature.id);
            
            m_creatures = new Dictionary();
            m_creatureCount = 0;
            m_thingUpdater.clear();
            m_creatureChecker.clear();
            m_effectList = new Vector.<Effect>();
            m_effectCount = 0;
            m_map.clear();
        }
        
        //--------------------------------------
        // Protected
        //--------------------------------------
        
        protected function updateTileFlags(item:Item, tile:Tile, removing:Boolean = false):void
        {
            var hasSolidMap:Boolean = (item.solidMap != null);
            var length:uint = hasSolidMap ? item.solidMap.length : 0;
            var columns:uint = item.solidMapColumns;
            var rows:uint = uint(length / columns);
            var pz:int = tile.z;
            var index:int = 0;
            
            if (length == 1) {
                if (removing) {
                    if (item.solidMap[index] != 0)
                        tile.resetFlag(TileFlags.SOLID);
                } else {
                    if (item.solidMap[index] != 0)
                        tile.setFlag(TileFlags.SOLID);
                }
            } else if (length > 1) {
                for (var y:int = rows - 1; y >= 0; y--) {
                    for (var x:int = columns - 1; x >= 0; x--) {
                        var px:int = tile.x - x;
                        var py:int = tile.y - y;
                        if (px > 0 && py > 0) {
                            var tmpTile:Tile = m_map.getTile(px, py, pz);
                            if (tmpTile) {
                                if (removing) {
                                    if (item.solidMap[index] != 0)
                                        tmpTile.resetFlag(TileFlags.SOLID);
                                } else {
                                    if (item.solidMap[index] != 0)
                                        tmpTile.setFlag(TileFlags.SOLID);
                                }
                            }
                        }
                        index++;
                    }
                }
            }
        }
    }
}
