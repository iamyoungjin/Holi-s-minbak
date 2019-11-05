package test.web.project03;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	BoardDAO(){}
	private static BoardDAO instance = new BoardDAO();
	public static BoardDAO getInstance() {
		return instance;
	}
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/xe");
		return ds.getConnection();
	}
	
	public int getPostCount(String search, String keyword) {
		int count = 0;
		String sql = "";
		try {
			conn = getConnection();
			if(search.equals("0")) {
				sql = "select count(*) from board_table"; 
				pstmt = conn.prepareStatement(sql);
			}else if(search.equals("1")) {
				sql = "select count(*) from board_table where subject like ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyword+"%");
			}else if(search.equals("2")) {
				sql = "select count(*) from board_table where content like ?"; 
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyword+"%");
			}else if(search.equals("3")) {
				sql = "select count(*) from board_table where name like ?"; 
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyword+"%");
			}
			rs = pstmt.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null) {try{rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return count;
	}
	
	/**
	 * @param start
	 * @param end
	 * @return
	 */
	public List getPosts(int start, int end, String search, String keyword) {
		List list = null;
		try {
			conn = getConnection();
			
			if(search.equals("0")) {
				String sql = "select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category,r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category, rownum r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category from "
						+ "board_table order by ref desc, re_step asc)"
						+ "order by ref desc, re_step asc)"
						+ "where r>=? and r<=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
				
			}else if(search.equals("1")) {
				String sql = "select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category,r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category, rownum r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category from "
						+ "board_table order by ref desc, re_step asc)"
						+ "where subject like ? order by ref desc, re_step asc)"
						+ "where r>=? and r<=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyword+"%");
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
				
			}else if(search.equals("2")) {
				String sql = "select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category,r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category, rownum r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category from "
						+ "board_table order by ref desc, re_step asc)"
						+ "where content like ? order by ref desc, re_step asc)"
						+ "where r>=? and r<=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyword+"%");
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
				
			}else if(search.equals("3")) {
				String sql = "select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category,r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category, rownum r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,fileroot,ref,re_step,re_level,category from "
						+ "board_table order by ref desc, re_step asc)"
						+ "where name like ? order by ref desc, re_step asc)"
						+ "where r>=? and r<=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, "%"+keyword+"%");
				pstmt.setInt(2, start);
				pstmt.setInt(3, end);
			}
			
			
			rs = pstmt.executeQuery();
			list = new ArrayList();
			while(rs.next()) {
				BoardDTO dto = new BoardDTO();
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setName(rs.getString("name"));
				dto.setId(rs.getString("id"));
				dto.setPw(rs.getString("pw"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setReg_date(rs.getTimestamp("reg_date"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setFileroot(rs.getString("fileroot"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setRe_level(rs.getInt("re_level"));
				dto.setCategory(rs.getInt("category"));
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
	
	public List getNotice() {
		List list = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from (select * from board_table where "
					+ "category=2 order by boardnum desc) where rownum<=3");
			rs= pstmt.executeQuery();
			list = new ArrayList();
			while(rs.next()) {
				BoardDTO dto = new BoardDTO();
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setName(rs.getString("name"));
				dto.setId(rs.getString("id"));
				dto.setPw(rs.getString("pw"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setReg_date(rs.getTimestamp("reg_date"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setFileroot(rs.getString("fileroot"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setRe_level(rs.getInt("re_level"));
				dto.setCategory(rs.getInt("category"));
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
	
	public boolean insertPost(BoardDTO dto) {
		boolean chk = false;
		int boardnum = dto.getBoardnum();
		int ref = dto.getRef();
		int re_step = dto.getRe_step();
		int re_level = dto.getRe_level();
		int number = 0;
		String sql = "";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select max(boardnum) from board_table");
			rs = pstmt.executeQuery();
			if(rs.next()) {
				number=rs.getInt(1)+1;
			}else {
				number = 1;
			}
			
			if(boardnum!=0) {
				sql = "update board_table set re_step=re_step+1 where ref=? and re_step>?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, re_step);
				pstmt.executeUpdate();
				re_step = re_step+1;
				re_level = re_level+1;
			}else {
				ref=number;
				re_step=0;
				re_level=0;
			}
			sql = "insert into board_table(boardnum, name, id, pw, subject, content, reg_date,"
					+ "fileroot, ref, re_step, re_level,category) values"
					+ "(board_table_seq.nextval,?,?,?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getId());
			pstmt.setString(3, dto.getPw());
			pstmt.setString(4, dto.getSubject());
			pstmt.setString(5, dto.getContent());
			pstmt.setTimestamp(6, dto.getReg_date());
			pstmt.setString(7, dto.getFileroot());
			pstmt.setInt(8, ref);
			pstmt.setInt(9, re_step);
			pstmt.setInt(10, re_level);
			pstmt.setInt(11, dto.getCategory());
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
	
	public BoardDTO getPost(int boardnum) {
		BoardDTO dto = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("update board_table set readcount=readcount+1 where boardnum=?");
			pstmt.setInt(1, boardnum);
			pstmt.executeUpdate();
			
			pstmt = conn.prepareStatement("select * from board_table where boardnum=?");
			pstmt.setInt(1, boardnum);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				dto = new BoardDTO();
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setCategory(rs.getInt("category"));
				dto.setName(rs.getString("name"));
				dto.setId(rs.getString("id"));
				dto.setPw(rs.getString("pw"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setReg_date(rs.getTimestamp("reg_date"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setRe_level(rs.getInt("re_level"));
				dto.setFileroot(rs.getString("fileroot"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null) {try{rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return dto;
	}
	
	
	public BoardDTO updateGetPost(int num) {
		BoardDTO dto = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from board_table where boardnum =?");
			pstmt.setInt(1,num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto = new BoardDTO();
				dto.setBoardnum(rs.getInt("boardnum"));
				dto.setCategory(rs.getInt("category"));
				dto.setName(rs.getString("name"));
				dto.setId(rs.getString("id"));
				dto.setPw(rs.getString("pw"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setReg_date(rs.getTimestamp("reg_date"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setRe_level(rs.getInt("re_level"));
				dto.setFileroot(rs.getString("fileroot"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null) {try{rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return dto;
	}
	
	public boolean updatePost(BoardDTO dto) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from board_table where boardnum = ?");
			pstmt.setInt(1, dto.getBoardnum());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				pstmt = conn.prepareStatement("update board_table set subject=?, content=?, fileroot=? where boardnum=?");
				pstmt.setString(1, dto.getSubject());
				pstmt.setString(2, dto.getContent());
				pstmt.setString(3, dto.getFileroot());
				pstmt.setInt(4, dto.getBoardnum());
				pstmt.executeUpdate();
				chk = true;
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
	
	public boolean deletePost(int boardnum, String id) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from board_table where boardnum=?");
			pstmt.setInt(1, boardnum);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				String dbid = rs.getString("id");
				if(id.equals("admin")){
					pstmt = conn.prepareStatement("delete from board_table where boardnum=?");
					pstmt.setInt(1, boardnum);
					pstmt.executeUpdate();
					chk = true; 
				}else if(dbid.equals(id)){
					pstmt = conn.prepareStatement("delete from board_table where boardnum=?");
					pstmt.setInt(1, boardnum);
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
	
	public boolean imageChk(File f, String[] ft, long s) {
		boolean chk = true;
		if(!ft[0].equals("image")) {
			chk = false;
		}
		if(s>(1024*1024*10)) {
			chk = false;
		}
		return chk;
	}
	
	public boolean selectDel(List<Integer> list) {
		boolean chk = false;
		try {
			if(list != null){
				conn = getConnection();
				for(int i=0; i<list.size(); i++) {
					if(list.get(i) != null) {
						pstmt = conn.prepareStatement("delete from board_table where boardnum=?");
						pstmt.setInt(1, list.get(i));
						pstmt.executeUpdate();
						chk = true;
					}else {
						chk = false;
					}
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return chk;
	}

}
