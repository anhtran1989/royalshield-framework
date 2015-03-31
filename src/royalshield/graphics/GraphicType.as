package royalshield.graphics
{
    import royalshield.animators.Animator;
    import royalshield.textures.SpriteSheet;
    
    public class GraphicType
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var id:uint;
        public var category:String;
        public var width:uint;
        public var height:uint;
        public var layers:uint;
        public var patternX:uint;
        public var patternY:uint;
        public var patternZ:uint;
        public var frames:uint;
        public var spriteSheet:SpriteSheet;
        public var animator:Animator;
        
        public var offsetX:uint;
        public var offsetY:uint;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function GraphicType()
        {
            this.width = 1;
            this.height = 1;
            this.layers = 1;
            this.patternX = 1;
            this.patternY = 1;
            this.patternZ = 1;
            this.frames = 1;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function getTotalSprites():uint
        {
            return this.width *
                   this.height *
                   this.patternX *
                   this.patternY *
                   this.patternZ *
                   this.frames *
                   this.layers;
        }
        
        public function getSpriteIndex(width:uint,
                                       height:uint,
                                       layer:uint,
                                       patternX:uint,
                                       patternY:uint,
                                       patternZ:uint,
                                       frame:uint):uint
        {
            return ((((((frame % this.frames) *
                    this.patternZ + patternZ) *
                    this.patternY + patternY) *
                    this.patternX + patternX) *
                    this.layers + layer) *
                    this.height + height) *
                    this.width + width;
        }
        
        public function getTotalTextures():uint
        {
            return this.patternX *
                   this.patternY *
                   this.patternZ *
                   this.frames *
                   this.layers;
        }
        
        public function getTextureIndex(layer:uint,
                                        patternX:uint,
                                        patternY:uint,
                                        patternZ:uint,
                                        frame:uint):int
        {
            return (((frame % this.frames *
                    this.patternZ + patternZ) *
                    this.patternY + patternY) *
                    this.patternX + patternX) *
                    this.layers + layer;
        }
    }
}
