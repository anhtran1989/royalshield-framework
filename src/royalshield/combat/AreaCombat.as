package royalshield.combat
{
    import flash.utils.Dictionary;
    
    import royalshield.core.RoyalShield;
    import royalshield.geom.Direction;
    import royalshield.geom.Position;
    import royalshield.world.Tile;
    import royalshield.world.WorldMap;
    
    public class AreaCombat
    {
        //--------------------------------------------------------------------------
        // PROPRIETIES
        //--------------------------------------------------------------------------
        
        private var m_hasExtArea:Boolean;
        private var m_matrixAreas:Dictionary;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function AreaCombat()
        {
            m_matrixAreas = new Dictionary();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function setupArea(list:Array, rows:uint):void
        {
            var northArea:MatrixArea = createMatrixArea(list, rows);
            var maxOutput:uint = Math.max(northArea.columns, northArea.rows) * 2;
            m_matrixAreas[Direction.NORTH] = northArea;
            
            var eastArea:MatrixArea = new MatrixArea(maxOutput, maxOutput);
            copyArea(northArea, eastArea, MatrixOperation.ROTATE_90);
            m_matrixAreas[Direction.EAST] = eastArea;
            
            var southArea:MatrixArea = new MatrixArea(maxOutput, maxOutput);
            copyArea(northArea, southArea, MatrixOperation.ROTATE_180);
            m_matrixAreas[Direction.SOUTH] = southArea;
            
            var westArea:MatrixArea = new MatrixArea(maxOutput, maxOutput);
            copyArea(northArea, westArea, MatrixOperation.ROTATE_270);
            m_matrixAreas[Direction.WEST] = westArea;
        }
        
        public function setupArea2(length:uint, spread:int):void
        {
            var list:Array = [];
            var columns:uint = 1;
            var rows:uint = length;
            
            if (spread != 0)
                columns = ((length - length % spread) / spread) * 2 + 1;
            
            var colSpread:int = columns;
            
            for (var y:uint = 1; y <= rows; y++) {
                var mincol:int = columns - colSpread + 1;
                var maxcol:int = columns - (columns - colSpread);
                
                for (var x:uint = 1; x <= columns; x++) {
                    if(y == rows && x == ((columns - columns % 2) / 2) + 1)
                        list[list.length] = 3;
                    else if(x >= mincol && x <= maxcol)
                        list[list.length] = 1; 
                    else
                        list[list.length] = 0;
                }
                
                if(spread > 0 && y % spread == 0)
                    colSpread--;
            }
            
            setupArea(list, rows);
        }
        
        public function setupAreaByRadius(radius:int):void
        {
            var list:Array = [];
            var columns:uint = 13;
            var rows:uint = 13;
            var area:Array = AreaCombatType.DEFAULT_AREA;
            
            for (var y:uint = 0; y < rows; y++) {
                for (var x:uint = 0; x < columns; x++) {
                    if(area[y][x] == 1)
                        list[list.length] = 3;
                    else if(area[y][x] > 0 && area[y][x] <= radius)
                        list[list.length] = 1;
                    else
                        list[list.length] = 0;
                }
            }
            
            setupArea(list, rows);
        }
        
        public function getList(center:Position, target:Position, positions:Vector.<Position>):Boolean
        {
            var matrix:MatrixArea = getMatrixArea(center, target);
            if (!matrix || !positions)
                return false;
            
            var map:WorldMap = RoyalShield.getInstance().world.map;
            var tile:Tile = null;
            var posx:int = target.x;
            var posy:int = target.y;
            var posz:int = target.z;
            var cols:uint = matrix.columns;
            var rows:uint = matrix.rows;
            
            posx -= matrix.centerX;
            posy -= matrix.centerY;
            
            for (var py:uint = 0; py < rows; py++) {
                for (var px:uint = 0; px < cols; px++) {
                    if (matrix.getValue(px, py)) {
                        if (map.inMapRange(posx, posy, posz)) {
                            if(map.isSightClear(target.x, target.y, target.z, posx, posy, posz, true)) {
                                tile = map.getTile(posx, posy, posz);
                                if(tile)
                                    positions[positions.length] = new Position(posx, posy, posz);
                            }
                        }
                    }
                    posx++;
                }
                posx -= cols;
                posy++;
            }
            return true;
        }
        
        public function clear():void
        {
            m_matrixAreas = new Dictionary();
        }
        
        //--------------------------------------
        // Protected
        //--------------------------------------
        
        protected function createMatrixArea(area:Array, rows:uint):MatrixArea
        {
            if (!area)
                return null;
            
            var length:uint = area.length;
            var columns:uint = length / rows;
            var matrix:MatrixArea = new MatrixArea(columns, rows);
            var x:uint;
            var y:uint;
            
            for (var i:uint = 0; i < length; i++) {
                var value:uint = area[i];
                if(value == 1 || value == 3)
                    matrix.setValue(x, y, true);
                
                if(value == 2 || value == 3)
                    matrix.setCenter(x, y);
                
                x++;
                if(columns == x) {
                    x = 0;
                    y++;
                }
            }
            return matrix;
        }
        
        protected function getMatrixArea(centerPosition:Position, targetPosition:Position):MatrixArea
        {
            var dx:int = targetPosition.x - centerPosition.x;
            var dy:int = targetPosition.y - centerPosition.y;
            var direction:Direction = Direction.NORTH;
            
            if(dx < 0)
                direction = Direction.WEST;
            else if(dx > 0)
                direction = Direction.EAST;
            else if(dy < 0)
                direction = Direction.NORTH;
            else 
                direction = Direction.SOUTH;
            
            if(m_hasExtArea) {
                if(dx < 0 && dy < 0)
                    direction = Direction.NORTHWEST;
                else if(dx > 0 && dy < 0)
                    direction = Direction.NORTHEAST;
                else if(dx < 0 && dy > 0)
                    direction = Direction.SOUTHWEST;
                else if(dx > 0 && dy > 0)
                    direction = Direction.SOUTHEAST;
            }
            
            if (m_matrixAreas[direction] != undefined)
                return m_matrixAreas[direction];
            
            return null;
        }
        
        protected function copyArea(input:MatrixArea, output:MatrixArea, operation:String):void
        {
            var centerX:uint = input.centerX;
            var centerY:uint = input.centerY;
            var x:uint;
            var y:uint;
            
            if (operation == MatrixOperation.COPY) {
                for (y = 0; y < input.rows; y++) {
                    for (x = 0; x < input.columns; x++)
                        output.setValue(x, y, input.getValue(x, y));
                }
                output.setCenter(centerX, centerY);
            } else if (operation == MatrixOperation.MIRROR) {
                var rx:int;
                for (y = 0; y < input.rows; y++) {
                    for (x = input.columns - 1; x >= 0; x--) {
                        output.setValue(rx, y, input.getValue(x, y));
                        rx++;
                    }
                }
                output.setCenter(centerY, (input.rows - 1) - centerX);
            } else if (operation == MatrixOperation.FLIP) {
                var ry:int;
                for (x = 0; x < input.columns; x++) {
                    for (y = input.rows - 1; y > 0; y--) {
                        output.setValue(x, ry, input.getValue(x, y));
                        ry++;
                    }
                }
                output.setCenter((input.columns - 1) - centerY, centerX);
            } else {
                var rotateCenterX:int = (output.columns / 2) - 1;
                var rotateCenterY:int = (output.rows / 2) - 1;
                var angle:Number = 0.0;
                
                switch (operation)
                {
                    case MatrixOperation.ROTATE_90:
                        angle = 90.0;
                        break;
                        
                    case MatrixOperation.ROTATE_180:
                        angle = 180.0;
                        break;
                        
                    case MatrixOperation.ROTATE_270:
                        angle = 270.0;
                        break;
                }
                
                var angleRad:Number = Math.PI * angle / 180.0;
                var a:Number = Math.cos(angleRad);
                var b:Number = -Math.sin(angleRad);
                var c:Number = Math.sin(angleRad);
                var d:Number = Math.cos(angleRad);
                
                for(x = 0; x < input.columns; x++) {
                    for(y = 0; y < input.rows; y++) {
                        // calculate new coordinates using rotation center
                        var newX:int = x - centerX;
                        var newY:int = y - centerY;
                        
                        // perform rotation
                        var rotatedX:int = Math.round(newX * a + newY * b);
                        var rotatedY:int = Math.round(newX * c + newY * d);
                        
                        // write in the output matrix using rotated coordinates
                        output.setValue(rotatedX + rotateCenterX, rotatedY + rotateCenterY, input.getValue(x, y));
                    }
                }
                output.setCenter(rotateCenterY, rotateCenterX);
            }
        }
    }
}
