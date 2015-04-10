package royalshield.core
{
    import royalshield.errors.AbstractClassError;
    
    public final class GameConsts
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function GameConsts()
        {
            throw new AbstractClassError(GameConsts);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const VIEWPORT_TILE_SIZE:uint = 32; // 32 x 32 pixels for each tile
        static public const VIEWPORT_TOTAL_TILES_X:uint = 18;
        static public const VIEWPORT_TOTAL_TILES_Y:uint = 14;
        static public const VIEWPORT_TILES_SUM:uint = VIEWPORT_TOTAL_TILES_X + VIEWPORT_TOTAL_TILES_Y;
        static public const VIEWPORT_TILES_TOTAL:uint = VIEWPORT_TOTAL_TILES_X * VIEWPORT_TOTAL_TILES_Y;
        static public const VIEWPORT_VISIBLE_TILES_X:uint = 15;
        static public const VIEWPORT_VISIBLE_TILES_Y:uint = 11;
        static public const VIEWPORT_WIDTH:uint = VIEWPORT_VISIBLE_TILES_X * VIEWPORT_TILE_SIZE;
        static public const VIEWPORT_HEIGHT:uint = VIEWPORT_VISIBLE_TILES_Y * VIEWPORT_TILE_SIZE;
        static public const VIEWPORT_PLAYER_OFFSET_X:uint = 8;
        static public const VIEWPORT_PLAYER_OFFSET_Y:uint = 6;
        static public const WORLD_UPDATE_INTERVAL:uint = 40;
        static public const WORLD_MAX_EFFECTS:uint = 100;
        
        static public const MIN_MAP_WIDTH:uint = 32;
        static public const MAX_MAP_WIDTH:uint = 1024;
        static public const MIN_MAP_HEIGHT:uint = 32;
        static public const MAX_MAP_HEIGHT:uint = 1024;
        static public const MIN_MAP_LAYERS:uint = 1;
        static public const MAX_MAP_LAYERS:uint = 8;
    }
}
