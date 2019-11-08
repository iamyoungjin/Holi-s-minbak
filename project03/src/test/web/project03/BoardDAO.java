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
	
	// 게시글의 갯수를 가져오는 메서드
	// count를 통해 boardList에서 페이지판 페이징을 사용하기 위해 쓰인다
	public int getPostCount(String search, String keyword) {
		int count = 0;
		String sql = "";
		try {
			conn = getConnection();
			// selectbox 에서 가져온 value와 검색할keyword를 통해서 DB에서 해당하는 게시글만 count한다
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
			// 오라클 쿼리에 %단어% 를 사용하여 해당 단어가 포함된 글을 찾는다.
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
	
	// boardList에 노출시킬 게시글을 가져온다
	// start로 설정된 값부터 end로 설정된 값까지 빼오며, 검색 사용시 이에 맞는 값을 빼온다
	
	public List getPosts(int start, int end, String search, String keyword) {
		List list = null;
		try {
			conn = getConnection();
			
			// 먼저, 게시글을 답글을 기준으로 정렬후, 이를 다시 rownum을 포함해 재정렬한다. 이후 rownum값을 start와 end값으로 짤라서 게시글을 원하는 만큼만 가져온다
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
			
			// 해당하는 게시글들을 rs에 담고, 이를 사용해 List에 담아 사용한다.
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
	
	// 공지사항 노출을 위한 메서드
	// 상단에 공지사항으로 노출시키기 위해 공지사항으로 설정된 글을 따로 빼서 List에 담는 메서드
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
	
	// 게시글 작성을 위한 메서드
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
			// 게시판의 글 갯수를 파악후 rs로 담고, 게시글이 없을시 number =1
			// 게시글이 있을시 현재 있는 게시글수 +1한 값을 number에 담는다
			// 게시글을 새로 작성시 boardnum 값은 없다. 그렇기 때문에 그경우 별다른 처리없이 re_step=0, re_level=0으로 설정후 ref는 boardnum(시퀀스) 값처럼 입력된다
			// 하지만 답글을 다는경우 boardnum 값을 가지고 온다. 그렇기 때문에 re_step과 re_level에 1을 더해줘서 답글의 상태를 지정해준다.
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
	
	// 게시글 번호를 매개변수로 게시판의 내용을 가져온다
	public BoardDTO getPost(int boardnum) {
		BoardDTO dto = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("update board_table set readcount=readcount+1 where boardnum=?");
			pstmt.setInt(1, boardnum);
			pstmt.executeUpdate();
			// 먼저, 글을 조회시 조회수를 +1한다. 이후 게시글의 내용을 DB로 조회하여 가져온다. 
			
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
	
	// 글 수정시 수정할 양식을 위해 글 내용을 가져온다
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
	// 글을 수정 한다
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
	// 글 삭제 메서드
	public boolean deletePost(int boardnum, String id) {
		boolean chk = false;
		try {
			conn = getConnection();
			// 먼저 게시글이 있는지 조회한다
			pstmt = conn.prepareStatement("select * from board_table where boardnum=?");
			pstmt.setInt(1, boardnum);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				// 게시글이 있을경우, db에서 작성자의 아이디를 꺼내온다. 
				String dbid = rs.getString("id");
				// 이후 매개변수 id가 admin (관리자) 일경우 그냥 삭제하고, 관리자가 아닐시 db의 작성자와 아이디가 같은지 검사후 삭제한다
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
	// 이미지 유효성 검사
	public boolean imageChk(File f, String[] ft, long s) {
		boolean chk = true;
		// 파일이 이미지형식이 아닐시 false
		if(!ft[0].equals("image")) {
			chk = false;
		}
		// 파일의 사이즈가 안맞을시 false
		if(s>(1024*1024*10)) {
			chk = false;
		}
		return chk;
	}
	
	// 관리자가 선택한 게시글을 삭제하기 위한 메서드
	// 매개변수는 checkbox 값을 담기 위하여 List를 사용하고, boardnum만 받게 제네릭 설정 <Integer>를 선언
	public boolean selectDel(List<Integer> list) {
		boolean chk = false;
		try {
			// list가 빈값을 가져오면 메서드 작동시키지 않기 위한 if문
			if(list != null){
				conn = getConnection();
				// for문으로 list의 사이즈 만큼 반복한다.
				for(int i=0; i<list.size(); i++) {
					// 혹시, list에 공백값이 들어갈 경우에 대한 예외처리
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
