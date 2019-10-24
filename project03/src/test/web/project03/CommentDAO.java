package test.web.project03;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class CommentDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private boolean chk = false;
	
	CommentDAO(){}
	private static CommentDAO instance = new CommentDAO();
	public static CommentDAO getInstance() {
		return instance;
	}
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/xe");
		return ds.getConnection();
	}
	
	
	public boolean insertComment(CommentDTO dto) {
		chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("insert into comment_table values(?,comment_table_seq.nextval,?,?,?,sysdate,?)");
			pstmt.setInt(1, dto.getPostnum());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getId());
			pstmt.setString(4, dto.getPw());
			pstmt.setString(5, dto.getComment_content());
			pstmt.executeUpdate();
			chk = true;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null) {try{rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		
		return chk;
	}
	public boolean deleteComment(int commentnum, String id) {
		chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from comment_table where commentnum=?");
			pstmt.setInt(1, commentnum);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				String dbid = rs.getString("id");
				if(id.equals(dbid)) {
					pstmt = conn.prepareStatement("delete from comment_table where commentnum=?");
					pstmt.setInt(1, commentnum);
					pstmt.executeUpdate();
					chk = true;
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null) {try{rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		
		return chk;
	}
	
	public List getComment(int boardnum) {
		List list = null;
		CommentDTO dto = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from comment_table where postnum=?");
			pstmt.setInt(1, boardnum);
			rs = pstmt.executeQuery();
			list = new ArrayList();
			while(rs.next()) {
				dto = new CommentDTO();
				dto.setPostnum(rs.getInt("postnum"));
				dto.setCommentnum(rs.getInt("commentnum"));
				dto.setName(rs.getString("name"));
				dto.setId(rs.getString("id"));
				dto.setPw(rs.getString("pw"));
				dto.setReg(rs.getTimestamp("reg"));
				dto.setComment_content(rs.getString("comment_content"));
				list.add(dto);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null) {try{rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return list;
	}
	
	
}
