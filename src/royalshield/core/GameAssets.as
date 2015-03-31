package royalshield.core
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    
    import royalshield.geom.Rect;
    import royalshield.graphics.GraphicType;
    import royalshield.textures.SpriteSheet;
    
    public class GameAssets
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function GameAssets()
        {
            
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function getSpriteSheet(type:GraphicType, texture:BitmapData):SpriteSheet
        {
            // Measures and creates the sprite sheet
            var size:uint = 32;
            var totalX:int = type.patternZ * type.patternX * type.layers;
            var totalY:int = type.frames * type.patternY;
            var bitmapWidth:Number = (totalX * type.width) * size;
            var bitmapHeight:Number = (totalY * type.height) * size;
            var pixelsWidth:int = type.width * size;
            var pixelsHeight:int = type.height * size;
            var rectList:Vector.<Rect> = new Vector.<Rect>(type.getTotalTextures(), true);
            var spriteSheet:SpriteSheet = new SpriteSheet(bitmapWidth, bitmapHeight, rectList);
            
            for (var f:uint = 0; f < type.frames; f++)
            {
                for (var z:uint = 0; z < type.patternZ; z++)
                {
                    for (var y:uint = 0; y < type.patternY; y++)
                    {
                        for (var x:uint = 0; x < type.patternX; x++)
                        {
                            for (var l:uint = 0; l < type.layers; l++)
                            {
                                var index:uint = type.getTextureIndex(l, x, y, z, f);
                                var fx:int = (index % totalX) * pixelsWidth;
                                var fy:int = Math.floor(index / totalX) * pixelsHeight;
                                rectList[index] = new Rect(fx, fy, pixelsWidth, pixelsHeight);
                                
                                /*for (var w:uint = 0; w < type.width; w++)
                                {
                                    for (var h:uint = 0; h < type.height; h++)
                                    {
                                        index = type.getSpriteIndex(w, h, l, x, y, z, f);
                                        var px:int = ((type.width - w - 1) * size);
                                        var py:int = ((type.height - h - 1) * size);
                                        copyPixels(index, spriteSheet, px + fx, py + fy);
                                    }
                                }*/
                            }
                        }
                    }
                }
            }
            
            // TODO: temporary!!!
            spriteSheet.copyPixels(texture, texture.rect, new Point());
            
            return spriteSheet;
        }
    }
}
