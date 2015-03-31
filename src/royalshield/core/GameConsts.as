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
        
        public static const VIEWPORT_TILE_SIZE:uint = 32; // 32 x 32 pixels for each tile
        public static const VIEWPORT_TOTAL_TILES_X:uint = 18;
        public static const VIEWPORT_TOTAL_TILES_Y:uint = 14;
        public static const VIEWPORT_TILES_SUM:uint = VIEWPORT_TOTAL_TILES_X + VIEWPORT_TOTAL_TILES_Y;
        public static const VIEWPORT_TILES_TOTAL:uint = VIEWPORT_TOTAL_TILES_X * VIEWPORT_TOTAL_TILES_Y;
        public static const VIEWPORT_VISIBLE_TILES_X:uint = 15;
        public static const VIEWPORT_VISIBLE_TILES_Y:uint = 11;
        public static const VIEWPORT_WIDTH:uint = VIEWPORT_VISIBLE_TILES_X * VIEWPORT_TILE_SIZE;
        public static const VIEWPORT_HEIGHT:uint = VIEWPORT_VISIBLE_TILES_Y * VIEWPORT_TILE_SIZE;
        public static const VIEWPORT_PLAYER_OFFSET_X:uint = 8;
        public static const VIEWPORT_PLAYER_OFFSET_Y:uint = 6;
        public static const WORLD_UPDATE_INTERVAL:uint = 40;
        public static const WORLD_MAX_EFFECTS:uint = 100;
    }
}
