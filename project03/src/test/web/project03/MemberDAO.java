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

import com.sun.org.apache.xpath.internal.operations.Equals;

public class MemberDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	// 주로 사용하는 커넥트, 프리페어스테이트먼트, 리설트셋 설정
	
	MemberDAO(){}
	private static MemberDAO instance = new MemberDAO();
	public static MemberDAO getInstance() {
		return instance;
	}
	// DB연결 싱글톤
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/xe");
		return ds.getConnection();
	}
	// 연결 메서드
	
	public boolean insert(MemberDTO dto) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("insert into member_table values(member_table_seq.nextval,?,?,?,?,?,?,2,sysdate)");
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getEmail());
			pstmt.setString(3, dto.getPw());
			pstmt.setString(4, dto.getName());
			pstmt.setString(5, dto.getPhonenum());
			pstmt.setString(6, dto.getBirthdate());
			pstmt.executeUpdate();
			chk = true;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return chk;
	}
	//  회원가입 메서드, DB에 insert 
		
	
	public boolean confirmId(String id) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select id from member_table");
			rs = pstmt.executeQuery();
			while(rs.next()) {
				if(rs.getString("id").equals(id)) {
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
	// 아이디 중복 검사 메서드
	
	public boolean login(String id,String pw) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=? and pw=?");
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				chk = true;
				if(rs.getInt("user_type") == 3) {
					chk = false;
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
	// 로그인 메서드
	
	public String searchName(String id) {
		String name=null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select name from member_table where id=?");
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				name = rs.getString("name");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null) {try{rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return name;
	}
	// 이름 찾기 메서드
	
	public MemberDTO getMember(String id) {
		MemberDTO dto = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=?");
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto = new MemberDTO();
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setEmail(rs.getString("email"));
				dto.setPhonenum(rs.getString("phonenum"));
				dto.setPw(rs.getString("pw"));
				dto.setBirthdate(rs.getString("birthdate"));
				dto.setUser_type(rs.getInt("user_type")); 
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
	// 회원 정보 수정에서 기존 정보 읽어오는 메서드
	
	public boolean modifyMember(String id, MemberDTO dto) {
		boolean chk = false;
		try {
			conn = getConnection();
			String sql = "update member_table set email=?, pw=?, name=?, phonenum=?, birthdate=? where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getEmail());
			pstmt.setString(2, dto.getPw());
			pstmt.setString(3, dto.getName());
			pstmt.setString(4, dto.getPhonenum());
			pstmt.setString(5, dto.getBirthdate());
			pstmt.setString(6, id);
			pstmt.executeUpdate();
			chk = true;
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return chk;
	}
	// 회원 정보 수정하는 메서드
	
	public int deleteMember(String id, String pw) {
		int res = 0;
		// res 기본값 0, try가 실행 되지 않을시 발생
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=? and pw=?");
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				pstmt = conn.prepareStatement("update member_table set user_type=3 where id=? and pw=?");
				pstmt.setString(1, id);
				pstmt.setString(2, pw);
				pstmt.executeUpdate();
				res = 1;
			}else{
				res = 2;
				// rs.next가 없다. 아이디와 비밀번호가 틀릴때.
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			if(rs!=null) {try{rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null) {try{pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null) {try{conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return res;
	}
	public List showMember() {
		List list = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where num!=1");
			rs = pstmt.executeQuery();
			list = new ArrayList();
			while(rs.next()) {
				MemberDTO dto = new MemberDTO();
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setEmail(rs.getString("email"));
				dto.setName(rs.getString("name"));
				dto.setPhonenum(rs.getString("phonenum"));
				dto.setBirthdate(rs.getString("birthdate"));
				dto.setReg(rs.getTimestamp("reg_date"));
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
	
	public boolean insertNaver(String id, String email, String name) {
		boolean chk= false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=?");
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				chk = false;
			}else {
				pstmt = conn.prepareStatement("insert into member_table values(member_table_seq.nextval,?,?,?,?,'null','null',4,sysdate)");
				pstmt.setString(1, id);
				pstmt.setString(2, email);
				pstmt.setString(3, id);
				pstmt.setString(4, name);
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
	public boolean loginNaver(String id) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=? and pw=?");
			pstmt.setString(1, id);
			pstmt.setString(2, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				chk = true;
				if(rs.getInt("user_type") == 3) {
					chk = false;
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
	public boolean insertKakao(String id) {
		boolean chk= false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=?");
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				chk = false;
			}else {
				pstmt = conn.prepareStatement("insert into member_table values(member_table_seq.nextval,?,'null',?,'null','null','null',4,sysdate)");
				pstmt.setString(1, id);
				pstmt.setString(2, id);
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
	public boolean loginKakao(String id) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=? and pw=?");
			pstmt.setString(1, id);
			pstmt.setString(2, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				chk = true;
				if(rs.getInt("user_type") == 3) {
					chk = false;
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
	public boolean insertGoogle(String id, String email) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=?");
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				chk = false;
			}else {
				pstmt = conn.prepareStatement("insert into member_table values(member_table_seq.nextval,?,?,?,'null','null','null',4,sysdate)");
				pstmt.setString(1, id);
				pstmt.setString(2, email);
				pstmt.setString(3, id);
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
	public boolean loginGoogle(String id) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=? and pw=?");
			pstmt.setString(1, id);
			pstmt.setString(2, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				chk = true;
				if(rs.getInt("user_type") == 3) {
					chk = false;
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
	
	public boolean chkInfoSnsLogin(String sId) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from member_table where id=?");
			pstmt.setString(1, sId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {	// 검색 결과값이 존재하는가?
				if(rs.getInt("user_type") == 4) {	// 유저타입이 4 = 소셜 로그인 인가?
					if(rs.getString("email").equals("null") || rs.getString("name").equals("null") ||
							rs.getString("phonenum").equals("null") || rs.getString("birthdate").equals("null")) {
						// 개인정보의 이메일, 이름, 전화번호, 생년월일 중 하나라도 null인가?
						chk = true;
					}
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
