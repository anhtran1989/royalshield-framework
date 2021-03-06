package royalshield.world
{
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    import royalshield.core.GameConsts;
    import royalshield.core.royalshield_internal;
    import royalshield.entities.creatures.Creature;
    import royalshield.entities.items.Item;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.geom.Direction;
    import royalshield.geom.Position;
    import royalshield.signals.Signal;
    import royalshield.utils.FindPathParams;
    import royalshield.utils.GameUtil;
    import royalshield.utils.isNullOrEmpty;
    import royalshield.world.utils.AStarNode;
    import royalshield.world.utils.AStarNodes;
    import royalshield.world.utils.FrozenPathingConditionCall;
    
    use namespace royalshield_internal;
    
    public class WorldMap implements IWorldMap
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_name:String;
        private var m_width:uint;
        private var m_height:uint;
        private var m_layers:uint;
        private var m_tiles:Dictionary;
        private var m_tileCount:uint;
        private var m_maxTileCount:uint;
        private var m_position:Position;
        private var m_nodes:AStarNodes;
        private var m_fpcc:FrozenPathingConditionCall;
        
        private var m_positionChangedSignal:Signal;
        private var m_dirtySignal:Signal;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get name():String { return m_name; }
        public function get width():uint { return m_width; }
        public function get height():uint { return m_height; }
        public function get layers():uint { return m_layers; }
        public function get tileCount():uint { return m_tileCount; }
        public function get x():uint { return m_position.x; }
        public function get y():uint { return m_position.y; }
        public function get z():uint { return m_position.z; }
        
        public function get onPositionChanged():Signal { return m_positionChangedSignal; }
        public function get onMapDirty():Signal { return m_dirtySignal; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function WorldMap(name:String, width:uint = 64, height:uint = 64, layers:uint = 1)
        {
            if (isNullOrEmpty(name))
                throw new NullOrEmptyArgumentError(name);
            
            m_name = name;
            m_width = Math.min(GameConsts.MAX_MAP_WIDTH, Math.max(GameConsts.MIN_MAP_WIDTH, width));
            m_height = Math.min(GameConsts.MAX_MAP_HEIGHT, Math.max(GameConsts.MIN_MAP_HEIGHT, height));
            m_layers = Math.min(GameConsts.MAX_MAP_LAYERS, Math.max(GameConsts.MIN_MAP_LAYERS, layers));
            m_tiles = new Dictionary();
            m_tileCount = 0;
            m_maxTileCount = m_width * m_height * m_layers;
            m_position = new Position();
            m_nodes = new AStarNodes();
            m_fpcc = new FrozenPathingConditionCall();
            
            m_positionChangedSignal = new Signal();
            m_dirtySignal = new Signal();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        /**
         * Checks if the position is valid.
         * 
         * @param x The X coordinate on the map.
         * @param y The Y coordinate on the map.
         * @param z The Z coordinate on the map.
         * @return Returns <code>true</code> if the position is valid.
         */
        public final function inMapRange(x:uint, y:uint, z:uint):Boolean
        {
            return (x < m_width && y < m_height && z < m_layers);
        }
        
        /**
         * Gets the tile index.
         * 
         * @param x The X coordinate on the map.
         * @param y The Y coordinate on the map.
         * @param z The Z coordinate on the map.
         * @return Returns the index of a position or -1 if it is an invalid position.
         */
        public function getTileIndex(x:uint, y:uint, z:uint):int
        {
            // For better performance, don't use inMapRange() here.
            if (x < m_width && y < m_height && z < m_layers)
                return (((z * m_width) + x) * m_height) + y;
            
            return -1;
        }
        
        /**
         * Returns the tile that belongs to a certain position of the map.
         * 
         * @param x The X coordinate on the map.
         * @param y The Y coordinate on the map.
         * @param z The Z coordinate on the map.
         */
        public function getTile(x:uint, y:uint, z:uint):Tile
        {
            // For better performance, don't use inMapRange() here.
            if (x < m_width && y < m_height && z < m_layers) {
                // For better performance, don't use getTileIndex() here.
                var index:int = (((z * m_width) + x) * m_height) + y;
                if (m_tiles[index] !== undefined)
                    return m_tiles[index];
            }
            return null;
        }
        
        /**
         * Returns the tile that belongs to a certain position of the map.
         * If the tile does not yet exists it is created.
         * 
         * @param x The X coordinate on the map.
         * @param y The Y coordinate on the map.
         * @param z The Z coordinate on the map.
         */
        public function setTile(x:uint, y:uint, z:uint, flags:uint = 0):Tile
        {
            // Check if it's in map range.
            if (x >= m_width || y >= m_height || z >= m_layers)
                return null;
            
            // Tile index.
            var index:int = (((z * m_width) + x) * m_height) + y;
            
            // Returns the tile if it already exists.
            if (m_tiles[index] !== undefined)
                return m_tiles[index];
            
            // Creates a new tile at the index.
            var tile:Tile = new Tile(x, y, z, flags);
            m_tiles[index] = tile;
            m_tileCount++;
            m_dirtySignal.dispatch();
            return tile;
        }
        
        public function getTileByIndex(index:int):Tile
        {
            if (index >= 0 && index < m_maxTileCount && m_tiles[index] !== undefined)
                return m_tiles[index];
            
            return null;
        }
        
        /**
         * TODO: add docs.
         * 
         * @param x The X coordinate on the map.
         * @param y The Y coordinate on the map.
         * @param z The Z coordinate on the map.
         */
        public function hasTileAt(x:uint, y:uint, z:uint):Boolean
        {
            // For better performance, don't use inMapRange() here.
            if (x < m_width && y < m_height && z < m_layers) {
                // For better performance, don't use getTileIndex() here.
                var index:int = (((z * m_width) + x) * m_height) + y;
                return (m_tiles[index] !== undefined);
            }
            return false;
        }
        
        /**
         * TODO: add docs.
         * 
         * @param x The X coordinate on the map.
         * @param y The Y coordinate on the map.
         * @param z The Z coordinate on the map.
         */
        public function deleteTileAt(x:uint, y:uint, z:uint):Boolean
        {
            if (x < m_width && y < m_height && z < m_layers) {
                // Tile index.
                var index:int = (((z * m_width) + x) * m_height) + y;
                if (m_tiles[index] !== undefined) {
                    delete m_tiles[index];
                    m_tileCount = Math.max(0, m_tileCount - 1);
                    m_dirtySignal.dispatch();
                    return true;
                }
            }
            return false;
        }
        
        public function deleteTile(tile:Tile):Boolean
        {
            return tile ? deleteTileAt(tile.x, tile.y, tile.z) : false;
        }
        
        public function setPosition(x:uint, y:uint, z:uint):void
        {
            if (m_position.x != x || m_position.y != y || m_position.z != z) {
                if (!inMapRange(x, y, z))
                    throw new ArgumentError("The coordinates are out of range.");
                
                m_position.setTo(x, y, z);
                m_positionChangedSignal.dispatch(x, y, z);
            }
        }
        
        public function moveCreature(creature:Creature, toTile:Tile):Boolean
        {
            if (!toTile.queryAdd(creature))
                return false;
            
            var fromTile:Tile = creature.tile;
            fromTile.removeCreature(creature);
            toTile.addCreature(creature);
            return true;
        }
        
        public function getWalkableTile(creature:Creature, x:uint, y:uint, z:uint):Tile
        {
            var tile:Tile = getTile(x, y, z);
            if (tile) {
                if (creature.tile != tile && !tile.queryAdd(creature))
                    return null;
                return tile;
            }
            return null;
        }
        
        public function getPathTo(creature:Creature, position:Position, directions:Vector.<Direction>, distance:int = -1, flags:uint = 0):Boolean
        {
            if (!creature || !directions)
                return false;
            
            if (getWalkableTile(creature, position.x, position.y, position.z) == null)
                return false;
            
            var startx:uint = position.x;
            var starty:uint = position.y;
            var startz:uint = position.z;
            var endx:uint = creature.tile.x;
            var endy:uint = creature.tile.y;
            var endz:uint = creature.tile.z;
            
            if (startz != endz)
                return false;
            
            directions.length = 0;
            m_nodes.clear();
            
            var posx:uint = 0;
            var posy:uint = 0;
            var posz:uint = startz;
            var startNode:AStarNode = m_nodes.createOpenNode();
            startNode.x = startx;
            startNode.y = starty;
            startNode.g = 0;
            startNode.h = m_nodes.getEstimatedDistance(startx, starty, endx, endy);
            startNode.f = startNode.g + startNode.h;
            startNode.parent = null;
            var found:AStarNode;
            
            while ((distance != -1) || (m_nodes.closedNodesLength < 100)) {
                var node:AStarNode = m_nodes.getBestNode();
                
                if (!node) {
                    directions.length = 0;
                    return false;
                }
                
                if ((node.x == endx) && (node.y == endy)) {
                    found = node;
                    break;
                } else {
                    var length:uint = RELATIONAL_POINTS.length;
                    for (var i:uint = 0; i < length; i++) {
                        var point:Point = RELATIONAL_POINTS[i];
                        posx = node.x + point.x;
                        posy = node.y + point.y;
                        var outOfRange:Boolean = false;
                        
                        if ((distance != -1) && ((Math.abs(endx - posx) > distance) || (Math.abs(endy - posy) > distance)))
                            outOfRange = true;
                        
                        if (!outOfRange) {
                            var tile:Tile = getWalkableTile(creature, posx, posy, posz);
                            if (tile) {
                                var cost:int = m_nodes.getMapWalkCost(creature, node, tile, posx, posy, posz);
                                var extraCost:int = m_nodes.getTileWalkCost(creature, tile);
                                var newg:int = node.g + cost + extraCost;
                                var neighbourNode:AStarNode = m_nodes.getNode(posx, posy);
                                
                                if (neighbourNode) {
                                    if (neighbourNode.g <= newg)
                                        continue;
                                    m_nodes.openNode(neighbourNode);
                                } else {
                                    neighbourNode = m_nodes.createOpenNode();
                                    if (!neighbourNode) {
                                        directions.length = 0;
                                        return false;
                                    }
                                }
                                
                                neighbourNode.x = posx;
                                neighbourNode.y = posy;
                                neighbourNode.parent = node;
                                neighbourNode.g = newg;
                                neighbourNode.h = m_nodes.getEstimatedDistance(neighbourNode.x, neighbourNode.y, endx, endy);
                                neighbourNode.f = neighbourNode.g + neighbourNode.h;
                            }
                        }
                    }
                    m_nodes.closeNode(node);
                }
            }
            return createPath(found, endx, endy, directions);
        }
        
        public function getPathMatching(creature:Creature, directions:Vector.<Direction>, targetPosition:Position, fpp:FindPathParams):Boolean
        {
            directions.length = 0;
            m_nodes.clear();
            m_fpcc.setTo(targetPosition);
            
            var startx:uint = creature.position.x;
            var starty:uint = creature.position.y;
            var startz:uint = creature.position.z;
            var endx:uint;
            var endy:uint;
            var endz:uint;
            var found:AStarNode;
            var posz:uint = startz;
            var startNode:AStarNode = m_nodes.createOpenNode();
            startNode.x = startx;
            startNode.y = starty;
            startNode.f = 0;
            startNode.parent = null;
            
            GameUtil.POINT.x = 0;
            
            while(fpp.maxSearchDist != -1 || m_nodes.closedNodesLength < 100) {
                var node:AStarNode = m_nodes.getBestNode();
                if (!node) {
                    if (found) break;
                    directions.length = 0;
                    return false;
                }
                
                if (m_fpcc.testPosition(startx, starty, startz, node.x, node.y, startz, fpp, GameUtil.POINT)) {
                    found = node;
                    endx = node.x;
                    endy = node.y;
                    endz = startz;
                    
                    if (GameUtil.POINT.x == 0) break;
                }
                
                var length:uint = (fpp.allowDiagonal ? 8 : 4);
                for (var i:int = 0; i < length; i++) {
                    var point:Point = RELATIONAL_POINTS[i];
                    var posx:uint = node.x + point.x;
                    var posy:uint = node.y + point.y;
                    var inRange:Boolean = true;
                    
                    if (fpp.maxSearchDist != -1 && (Math.abs(startx - posx) > fpp.maxSearchDist || Math.abs(starty - posy) > fpp.maxSearchDist)) 
                        inRange = false;
                    
                    if(fpp.keepDistance) {
                        if(!m_fpcc.inRange(startx, starty, startz, posx, posy, posz, fpp))
                            inRange = false;
                    }
                    
                    if(inRange) {
                        var tile:Tile = getWalkableTile(creature, posx, posy, posz);
                        if (tile) {
                            var cost:int = m_nodes.getMapWalkCost(creature, node, tile, posx, posy, posz);
                            var extraCost:int = m_nodes.getTileWalkCost(creature, tile);
                            var newf:int = (node.f + cost + extraCost);
                            var neighbourNode:AStarNode = m_nodes.getNode(posx, posy);
                            
                            if (neighbourNode) {
                                if(neighbourNode.f <= newf) continue;
                                m_nodes.openNode(neighbourNode);
                            } else {
                                neighbourNode = m_nodes.createOpenNode();
                                if(!neighbourNode) {
                                    if(found) break;
                                    directions.length = 0;
                                    return false;
                                }
                                
                                neighbourNode.x = posx;
                                neighbourNode.y = posy;
                            }
                            
                            neighbourNode.parent = node;
                            neighbourNode.f = newf;
                        }
                    }
                }
                
                m_nodes.closeNode(node);
            }
            
            return found ? createPathMatching(found, endx, endy, directions) : false;
        }
        
        public function isSightClear(fromX:uint, fromY:uint, fromZ:uint, toX:uint, toY:uint, toZ:uint, floorCheck:Boolean):Boolean
        {
            return true;
        }
        
        public function getSpectators(x:uint, y:uint, z:uint, list:Vector.<Creature>, multifloor:Boolean = false):void
        {
            if (!inMapRange(x, y, z) || !list)
                return;
            
            var minRangeX:uint = Math.max(0, x - MAX_VIEWPORT_X);
            var maxRangeX:uint = x + MAX_VIEWPORT_X;
            var minRangeY:uint = Math.max(0, y - MAX_VIEWPORT_Y);
            var maxRangeY:uint = y + MAX_VIEWPORT_Y;
            
            for (x = minRangeX; x < maxRangeX; x++) {
                for (y = minRangeY; y < maxRangeY; y++) {
                    var tile:Tile = getTile(x, y, z);
                    if (tile) {
                        var creature:Creature = tile.firstCreature;
                        while (creature) {
                            if (list.indexOf(creature) == -1)
                                list[list.length] = creature;
                            creature = creature.next;
                        }
                    }
                }
            }
        }
        
        public function getTopItemAt(x:uint, y:uint, z:uint):Item
        {
            var tile:Tile = getTile(x, y, z);
            if (tile)
                return tile.getItemAt(tile.itemCount - 1);
            
            return null;
        }
        
        public function clear():void
        {
            if (m_tileCount != 0) {
                m_tiles = new Dictionary();
                m_tileCount = 0;
            }
            
            m_positionChangedSignal.removeAll();
            m_dirtySignal.removeAll();
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function createPath(node:AStarNode, x:int, y:int, directions:Vector.<Direction>):Boolean
        {
            if (!node || !directions)
                return false;
            
            var prevx:int = x;
            var prevy:int = y;
            
            while (node) {
                var posx:int = node.x;
                var posy:int = node.y;
                var dx:int = posx - prevx;
                var dy:int = posy - prevy;
                prevx = posx;
                prevy = posy;
                
                if ((dx == -1) && (dy == -1))
                    directions[directions.length] = Direction.NORTHWEST;
                else if(dx == 1 && dy == -1)
                    directions[directions.length] = Direction.NORTHEAST;
                else if(dx == -1 && dy == 1)
                    directions[directions.length] = Direction.SOUTHWEST;
                else if(dx == 1 && dy == 1)
                    directions[directions.length] = Direction.SOUTHEAST;
                else if(dx == -1)
                    directions[directions.length] = Direction.WEST;
                else if(dx == 1)
                    directions[directions.length] = Direction.EAST;
                else if(dy == -1)
                    directions[directions.length] = Direction.NORTH;
                else if(dy == 1)
                    directions[directions.length] = Direction.SOUTH;
                
                node = node.parent;
            }
            return (directions.length != 0);
        }
        
        private function createPathMatching(node:AStarNode, x:int, y:int, directions:Vector.<Direction>):Boolean
        {
            if (!node || !directions)
                return false;
            
            var prevx:int = x;
            var prevy:int = y;
            node = node.parent;
            
            while (node) {
                var posx:int = node.x;
                var posy:int = node.y;
                var dx:int = posx - prevx;
                var dy:int = posy - prevy;
                prevx = posx;
                prevy = posy;
                
                if (dx == 1 && dy == 1)
                    directions.unshift(Direction.NORTHWEST);
                else if (dx == -1 && dy == 1)
                    directions.unshift(Direction.NORTHEAST);
                else if (dx == 1 && dy == -1)
                    directions.unshift(Direction.SOUTHWEST);
                else if (dx == -1 && dy == -1)
                    directions.unshift(Direction.SOUTHEAST);
                else if (dx == 1)
                    directions.unshift(Direction.WEST);
                else if (dx == -1)
                    directions.unshift(Direction.EAST);
                else if (dy == 1)
                    directions.unshift(Direction.NORTH);
                else if (dy == -1)
                    directions.unshift(Direction.SOUTH);
                
                node = node.parent;
            }
            return true;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const NORMAL_WALK_COST:uint = 10;
        static public const DIAGONAL_WALK_COST:uint = 25;
        static public const MAX_VIEWPORT_X:uint = 11;
        static public const MAX_VIEWPORT_Y:uint = 11;
        
        static private const RELATIONAL_POINTS:Vector.<Point> = new <Point>[new Point(-1,  0),
                                                                            new Point( 0,  1),
                                                                            new Point( 1,  0),
                                                                            new Point( 0, -1),
                                                                            /*diagonal*/
                                                                            new Point(-1, -1),
                                                                            new Point( 1, -1),
                                                                            new Point( 1,  1),
                                                                            new Point(-1,  1)];
    }
}
