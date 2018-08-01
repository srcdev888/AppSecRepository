package com.concretepage;

import org.apache.ibatis.datasource.pooled.PooledDataSource;
import org.apache.ibatis.datasource.unpooled.UnpooledDataSource;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.jdbc.ScriptRunner;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.Reader;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class BaseDataTest {

	public static UnpooledDataSource createUnpooledDataSource(String resource) throws IOException {
		Properties props = Resources.getResourceAsProperties(resource);
		UnpooledDataSource ds = new UnpooledDataSource();
		ds.setDriver(props.getProperty("driver"));
		ds.setUrl(props.getProperty("url"));
		ds.setUsername(props.getProperty("username"));
		ds.setPassword(props.getProperty("password"));
		return ds;
	}

	public static PooledDataSource createPooledDataSource(String resource) throws IOException {
		Properties props = Resources.getResourceAsProperties(resource);
		PooledDataSource ds = new PooledDataSource();
		ds.setDriver(props.getProperty("driver"));
		ds.setUrl(props.getProperty("url"));
		ds.setUsername(props.getProperty("username"));
		ds.setPassword(props.getProperty("password"));
		return ds;
	}

	public static void runScript(DataSource ds, String resource) throws IOException, SQLException {
		Connection connection = ds.getConnection();
		try {
			ScriptRunner runner = new ScriptRunner(connection);
			runner.setAutoCommit(true);
			runner.setStopOnError(false);
			runner.setLogWriter(null);
			runner.setErrorLogWriter(null);
			runScript(runner, resource);
		} finally {
			connection.close();
		}
	}

	public static void runScript(ScriptRunner runner, String resource) throws IOException, SQLException {
		Reader reader = Resources.getResourceAsReader(resource);
		try {
			runner.runScript(reader);
		} finally {
			reader.close();
		}
	}

}
