package gamescene.interfaces {
	import gamescene.GameObject;

	public interface IGameObjectContainer {
		
		/**
		 * Adds a child to this game object
		 * */
		function addChild(child:GameObject):void;
		
		/**
		 * Adds a child at the specified index
		 * */
		function addChildAt(child:GameObject, index:int):void;
		
		/**
		 * Removes the specified child
		 * */
		function removeChild(child:GameObject):void;
		
		/**
		 * Removes the child at the specified index
		 * */
		function removeChildAt(index:int):void;
		
		/**
		 * Changes a child's index
		 * */
		function setChildIndex(child:GameObject, index:int):void;
		
		/**
		 * Swaps 2 childen indices
		 * */
		 function swapChildren(child1:GameObject, child2:GameObject):void;
		
		/**
		 * Swaps 2 childen indices
		 * */
		function swapChildrenAt(index1:int, index2:int):void;
	}
}