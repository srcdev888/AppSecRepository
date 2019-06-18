////////////////////////////////////////////////////
// Exercise 2.1:
//   Flow from input to sink, where:
//		input is method "GetSpeed" invocation
//		sink is parameter invocation of Car.Drive 
//
// Exercise 2.2:
//	Like 2.1, but the sink is the parameter of 
//	method declaration "Drive" that overrides Car.Drive
////////////////////////////////////////////////////
namespace ns
{
	class Car
	{
		public Color color {set; get;}
		public virtual void Drive(int speed)
		{
			// Drive implementation
		}
	}
	
	class Toyota : Car
	{
	}
	
	class Honda : Car
	{
		public override void Drive(int speed)
		{
			// Drive implementation for Honda
		}
	}
	
	class Program
	{
		static void main()
		{
			int speed = GetSpeed();
			var my = new Toyota();
			var myOther = new Honda();
			my.Drive(speed);
			myOther.Drive(speed);
		}
	}
}