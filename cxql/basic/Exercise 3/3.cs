////////////////////////////////////////////////////
// Exercise 3.1 (SQL injection):
//   Find flow from the input to the sink.
//   The input is the method GetName()
//   The sink is the first parameter of Database.execute
//
// Exercise 3.2
//   Like exercise 3.1, with the following addition:
//   Function encode sanitizes the input.
//
// Exercise 3.3
//   Like exercise 3.2, with the following addition:
//   Function CheckIfValid sanitizes the input.
////////////////////////////////////////////////////
namespace ns
{
	class Team
	{
		public int Id {get; set;}
		public string Name {get; set;}

		public void Foo()
		{
			string validated;
			string name = GetName();
			if(CheckIfValid(name))
			{
				GetBalance(validated);
			}
		}

		public void Foo1(){
			string name = GetName();
			if(!CheckIfValid(name)){
				GetBalance(name);
			}
		}

		public void Foo2(){
			string name = GetName();
			if(!CheckIfValid(name)){

			}
			GetBalance(name);
		}

		public void Foo3(){
			string name = GetName();
			string encoded = encode(name);
			GetBalance(encoded);
		}


		private GetBalance(string name)
		{
			string query = "select * from balance where name=" + name;
			Database db = GetDb();
			Row r = db.execute(query);
			ShowMessage("User " + user + ", Your balance is " + r.balance);
		}

	}
}
