////////////////////////////////////////////////////
// Exercise 1.1:
//    Find all nodes whose name is "input" (not case sensitive) 
//
// Exerecise 1.2:
//   Find all methods whose name is "input" (not case sensitive)
//
// Exercise 1.3:
//    Find all nodes whose name is "input" (not case sensitive) 
//    under an "if" statement
////////////////////////////////////////////////////
namespace ns
{
	class User
	{
		public int Id {get; set;}
		public string Name {get; set;}
		private string Input = "Input";
		
		public void Input(string name)
		{
			this.Name = name;
			if(input())
			{
				name += Input;
			}else{
				input = "mycustom";
			}
		}
		
		virtual private bool input()
		{
			return false;
		}
		
	}
}