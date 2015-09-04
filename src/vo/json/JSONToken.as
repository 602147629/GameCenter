package vo.json
{
	
	public final class JSONToken
	{
		
		/**
		 * The type of the token.
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public var type:int;
		
		/**
		 * The value of the token
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public var value:Object;
		
		/**
		 * Creates a new JSONToken with a specific token type and value.
		 *
		 * @param type The JSONTokenType of the token
		 * @param value The value of the token
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public function JSONToken( type:int = -1 /* JSONTokenType.UNKNOWN */, value:Object = null )
		{
			this.type = type;
			this.value = value;
		}
		
		/**
		 * Reusable token instance.
		 * 
		 * @see #create()
		 */
		internal static const token:JSONToken = new JSONToken();
		
		/**
		 * Factory method to create instances.  Because we don't need more than one instance
		 * of a token at a time, we can always use the same instance to improve performance
		 * and reduce memory consumption during decoding.
		 */
		internal static function create( type:int = -1 /* JSONTokenType.UNKNOWN */, value:Object = null ):JSONToken
		{
			token.type = type;
			token.value = value;
			
			return token;
		}
	}
}