package data
{
	public dynamic class GameData
	{
		public var playerData:PlayerData;
		public var enemyData:EnemyData;
		
		public function GameData()
		{
			playerData = new PlayerData();
			enemyData = new EnemyData();
		}
	}
}