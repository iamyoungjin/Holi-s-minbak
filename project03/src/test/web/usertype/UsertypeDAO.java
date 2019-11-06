package test.web.usertype;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import test.web.project03.RoomDAO;

public class UsertypeDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	UsertypeDAO(){}
	private static UsertypeDAO instance = new UsertypeDAO();
	public static UsertypeDAO getInstance() {
		return instance;
	}
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/xe");
		return ds.getConnection();
	}
	
	public String getType(int user_type) {
		String str = "";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select status from user_type_table where user_type=?");
			pstmt.setInt(1, user_type);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				str = rs.getString("status");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs!=null){try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return str;
	}
	
	
	
}
