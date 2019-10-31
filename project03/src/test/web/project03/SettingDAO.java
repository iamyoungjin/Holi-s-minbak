package test.web.project03;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class SettingDAO {
	// 게시판 설정을 위한 테이블/DAO
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	SettingDAO(){}
	private static SettingDAO instance = new SettingDAO();
	public static SettingDAO getInstance() {
		return instance;
	}
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/xe");
		return ds.getConnection();
	}
	
	public boolean sizeSetting(int pageSize, int imgSize) {
		boolean chk = false;
		try {
			conn = getConnection();
			if(pageSize<=20 && pageSize>=5) {
				if(imgSize<=20 && imgSize>=5) {
					pstmt = conn.prepareStatement("update setting_table set pageSize=?, imgSize=?");
					pstmt.setInt(1, pageSize);
					pstmt.setInt(2, imgSize);
					pstmt.executeUpdate();
					chk = true;
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return chk;
	}
	public SettingDTO getSetting() {
		SettingDTO dto = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from setting_table where boardtype='board'");
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto = new SettingDTO();
				dto.setPagesize(rs.getInt("pageSize"));
				dto.setImgsize(rs.getInt("imgSize"));
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null){try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return dto;
	}
	

}