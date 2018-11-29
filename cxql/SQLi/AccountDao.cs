namespace ns1
{

    class AccountDao
    {
    
		SqlConnection conn = new SqlConnection(connectionString);
			
		// Example 1: parameters not sanitized
		public void newUser(TextBox tbUserName, TextBox tbPassword)
        {
			
			string username = tbUserName.Text;
			string password = tbPassword.Text;
			
			string sql = "INSERT INTO users(name, pwd) VALUES ('" + username + "','" + password + "')";
			MySqlCommand cmd = new MySqlCommand(sql, conn);
			conn.Open();
			SqlDataReader reader = cmd.ExecuteReader();
        }

		
		
		
		
		// Example 2: Sanitized parameters
		public void deleteUser(TextBox tbUserName)
		{
			string username = tbUserName.Text;
			string sql = "DELETE from users WHERE name = @param1";
            MySqlCommand cmd = new MySqlCommand(sql, connection);
            cmd.Parameters.AddWithValue(@param1, username);
            cmd.ExecuteNonQuery();
		}
		


		
		// Example 3: Sanitization method not recognized
		public void changeStatus(TextBox tbUserName, TextBox tbStatus){
			
			string username = tbUserName.Text;
			string status = tbStatus.Text;
			
			string sql = mySuperclean("UPDATE users SET status = '" + status + "' WHERE name = '" + username + "'");
			MySqlCommand cmd = new MySqlCommand(sql, conn);
			conn.Open();
			SqlDataReader reader = cmd.ExecuteReader();
		}
		
		
		
		
		
		// Example 4: interactive input not detected
		public void getUser(){
		
			string sql = "SELECT FROM users WHERE id='" + CurrentUser.getId() + "'";
			MySqlCommand cmd = new MySqlCommand(sql, conn);
			conn.Open();
			SqlDataReader reader = cmd.ExecuteReader();
		}
		
		
		
    }
}