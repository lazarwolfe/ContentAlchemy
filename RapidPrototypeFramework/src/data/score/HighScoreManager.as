package data.score
{
	public class HighScoreManager
	{
		private var highScoreList:Vector.<HighScoreData> = new Vector.<HighScoreData>();
		
		private static var instance:HighScoreManager;
		
		public static function getInstance():HighScoreManager
		{
			if(instance)
			{
				//
				instance = new HighScoreManager();
			}
			
			return instance;
		}
		
		public function HighScoreManager()
		{
		}
		
		public function saveScore(name:String, score:int):void
		{
			var scoreData:HighScoreData = new HighScoreData();
			scoreData.name = name;
			scoreData.score = score;
			highScoreList.push(scoreData);
			
			highScoreList.sort(sortScore);
		}
		
		public function loadScore():Vector.<HighScoreData>
		{
			return highScoreList;
		}
		
		
		private function sortScore(a:HighScoreData, b:HighScoreData):Number
		{
			return a.score - b.score;
		}
	}
}