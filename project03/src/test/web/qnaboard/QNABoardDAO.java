package test.web.qnaboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import test.web.project03.BoardDTO;

	public class QNABoardDAO {
		private Connection conn = null;
		private PreparedStatement pstmt = null;
		private ResultSet rs = null;
		
		QNABoardDAO(){}
		private static QNABoardDAO instance = new QNABoardDAO();
		public static QNABoardDAO getInstance() {
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
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement("select count(*) from board_qnatable");
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
				String sql = "select boardnum,name,id,pw,subject,content,reg_date,readcount,ref,re_step,re_level,category,r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,ref,re_step,re_level,category, rownum r from"
						+ "(select boardnum,name,id,pw,subject,content,reg_date,readcount,ref,re_step,re_level,category from board_qnatable order by ref desc, re_step asc)"
						+ "order by ref desc, re_step asc)"
						+ "where r>=? and r<=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, start);
				pstmt.setInt(2, end);
				rs = pstmt.executeQuery();
				list = new ArrayList();
				while(rs.next()) {
					QNABoardDTO dto = new QNABoardDTO();
					dto.setBoardnum(rs.getInt("boardnum"));
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
				pstmt = conn.prepareStatement("select * from (select * from board_qnatable where "
						+ "category=2 order by boardnum desc) where rownum<=3");
				rs= pstmt.executeQuery();
				list = new ArrayList();
				while(rs.next()) {
					QNABoardDTO dto = new QNABoardDTO();
					dto.setBoardnum(rs.getInt("boardnum"));
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
		
		public boolean insertPost(QNABoardDTO dto) {
			boolean chk = false;
			int boardnum = dto.getBoardnum();
			int ref = dto.getRef();
			int re_step = dto.getRe_step();
			int re_level = dto.getRe_level();
			int number = 0;
			String sql = "";
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement("select max(boardnum) from board_qnatable");
				rs = pstmt.executeQuery();
				if(rs.next()) {
					number=rs.getInt(1)+1;
				}else {
					number = 1;
				}
				
				if(boardnum!=0) {
					sql = "update board_qnatable set re_step=re_step+1 where ref=? and re_step>?";
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
				sql = "insert into board_qnatable(boardnum,name,id,pw,subject,content,reg_date,"
						+ " ref, re_step, re_level,category) values"
						+ "(board_qnatable_seq.nextval,?,?,?,?,?,?,?,?,?,?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, dto.getName());
				pstmt.setString(2, dto.getId());
				pstmt.setString(3, dto.getPw());
				pstmt.setString(4, dto.getSubject());
				pstmt.setString(5, dto.getContent());
				pstmt.setTimestamp(6, dto.getReg_date());
				pstmt.setInt(7, ref);
				pstmt.setInt(8, re_step);
				pstmt.setInt(9, re_level);
				pstmt.setInt(10, dto.getCategory());
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
		
		public QNABoardDTO getPost(int boardnum) {
			QNABoardDTO dto = null;
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement("update board_qnatable set readcount=readcount+1 where boardnum=?");
				pstmt.setInt(1, boardnum);
				pstmt.executeUpdate();
				
				pstmt = conn.prepareStatement("select * from board_qnatable where boardnum=?");
				pstmt.setInt(1, boardnum);
				rs=pstmt.executeQuery();
				if(rs.next()) {
					dto = new QNABoardDTO();
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
		
		
		public QNABoardDTO updateGetPost(int num) {
			QNABoardDTO dto = null;
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement("select * from board_qnatable where boardnum =?");
				pstmt.setInt(1,num);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					dto = new QNABoardDTO();
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
		
		public boolean updatePost(QNABoardDTO dto) {
			boolean chk = false;
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement("select * from board_qnatable where boardnum = ?");
				pstmt.setInt(1, dto.getBoardnum());
				rs = pstmt.executeQuery();
				if(rs.next()) {
					pstmt = conn.prepareStatement("update board_qnatable set subject=?, content=? where boardnum=?");
					pstmt.setString(1, dto.getSubject());
					pstmt.setString(2, dto.getContent());
					pstmt.setInt(3, dto.getBoardnum());
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
		
		public boolean deletePost(QNABoardDTO dto) {
			boolean chk = false;
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement("select * from board_qnatable where boardnum=? and pw =?");
				pstmt.setInt(1, dto.getBoardnum());
				pstmt.setString(2,dto.getPw());
				rs = pstmt.executeQuery();
				if(rs.next()) {
					String dbpw = rs.getString("pw");
					if(dbpw.equals(dto.getPw())) {
						pstmt = conn.prepareStatement("delete from board_qnatable where boardnum=?");
						pstmt.setInt(1, dto.getBoardnum());
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
}
