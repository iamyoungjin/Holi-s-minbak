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

public class RoomDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// 싱글톤 패턴
	RoomDAO(){}
	private static RoomDAO instance = new RoomDAO();
	public static RoomDAO getInstance() {
		return instance;
	}
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/xe");
		return ds.getConnection();
	}
	
	// checkRoomData에서 사용하는, 방 정보를 빼와서 dto에 담고, dto를 List에 넣는 메서드다
	// 관리자가 모든 방의 정보를 보기 위해 사용한다.
	// 또한, roomIntro에서도 방의 리스트를 뽑기 위해 사용한다
	public List showRoom() {
		List list = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from room_table order by num");
			rs = pstmt.executeQuery();
			list = new ArrayList();
			while(rs.next()) {
				RoomDTO dto = new RoomDTO();
				dto.setNum(rs.getInt("num"));
				dto.setRname(rs.getString("rname"));
				dto.setDpeople(rs.getInt("dpeople"));
				dto.setMaxpeople(rs.getInt("maxpeople"));
				dto.setAddtionalcost(rs.getInt("addtionalcost"));
				dto.setWeekday_price(rs.getInt("weekday_price"));
				dto.setWeekend_price(rs.getInt("weekend_price"));
				dto.setPeakseason_price(rs.getInt("peakseason_price"));
				list.add(dto);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs!=null){try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return list;
	}
	
	// 방 추가를 위한 메서드
	public boolean insertRoom(RoomDTO dto) {
		boolean chk = true;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from room_table where rname=?");
			pstmt.setString(1, dto.getRname());
			rs = pstmt.executeQuery();
			// rname은 primary key다. 그러므로 중복 값을 피하기위해 검사후 데이터를 집어넣는다. 
			if(rs.next()) {
				chk=false;
			}else{	
				pstmt = conn.prepareStatement("insert into room_table values(ROOM_TABLE_SEQ.NEXTVAL,?,?,?,?,?,?,?,'','없음')");
				pstmt.setString(1, dto.getRname());
				pstmt.setInt(2, dto.getDpeople());
				pstmt.setInt(3, dto.getMaxpeople());
				pstmt.setInt(4, dto.getAddtionalcost());
				pstmt.setInt(5, dto.getWeekday_price());
				pstmt.setInt(6, dto.getWeekend_price());
				pstmt.setInt(7, dto.getPeakseason_price());
				pstmt.executeUpdate();
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs!=null){try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return chk;
	}
	
	// 방 정보 수정 메서드
	// showRoom 메서드로 빼온 정보를 다시 수정해서 DB에 update하기 위해 사용한다.
	public void updateRoom(RoomDTO dto) {
		try {
			conn = getConnection();
			String sql = "update room_table set rname=?,dpeople=?,maxpeople=?,"
					+ "addtionalcost=?,weekday_price=?,weekend_price=?,peakseason_price=? where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getRname());
			pstmt.setInt(2, dto.getDpeople());
			pstmt.setInt(3, dto.getMaxpeople());
			pstmt.setInt(4, dto.getAddtionalcost());
			pstmt.setInt(5, dto.getWeekday_price());
			pstmt.setInt(6, dto.getWeekend_price());
			pstmt.setInt(7, dto.getPeakseason_price());
			pstmt.setInt(8, dto.getNum());
			pstmt.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
	}
	
	// 방 삭제 메서드
	// 방은 굳이 삭제이전 기록을 남겨야 할 이유가 없으므로, delete로 지운다.
	public void deleteRoom(RoomDTO dto) {
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from room_table where num=?");
			pstmt.setInt(1, dto.getNum());
			rs= pstmt.executeQuery();
			// 지우기 전 해당하는 방의 번호가 정확한 값인지 확인한다, 
			if(rs.next()) {
				pstmt = conn.prepareStatement("delete from room_table where num=?");
				pstmt.setInt(1, dto.getNum());
				pstmt.executeUpdate();
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs!=null){try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		
	}
	
	
	// roomIntro 에서 showRoom 메서드를 통해 가져온 num값을 이용하여 사용하여 해당하는 방 하나의 정보만을 빼온다.
	public RoomDTO getRoomData(int roomnum) {
		RoomDTO dto = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from room_table where num=?");
			pstmt.setInt(1, roomnum);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto = new RoomDTO();
				dto.setNum(rs.getInt("num"));
				dto.setRname(rs.getString("rname"));
				dto.setDpeople(rs.getInt("dpeople"));
				dto.setMaxpeople(rs.getInt("maxpeople"));
				dto.setAddtionalcost(rs.getInt("addtionalcost"));
				dto.setWeekday_price(rs.getInt("weekday_price"));
				dto.setWeekend_price(rs.getInt("weekend_price"));
				dto.setPeakseason_price(rs.getInt("peakseason_price"));
				dto.setRoom_img(rs.getString("room_img"));
				dto.setIntro(rs.getString("intro"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs!=null){try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return dto;
	}
	
	// 방 소개 문구 수정 메서드
	// 방의 번호와 dto(기존정보)를 매개변수로 방정보를 작성한다
	public boolean updateIntro(int roomnum, RoomDTO dto) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from room_table where num=?");
			pstmt.setInt(1, roomnum);
			rs = pstmt.executeQuery();
			// 방 번호가 존재하는지 확인한다. 이후 존재할시 이미지파일과 소개문구를 업데이트한다
			if(rs.next()) {
				pstmt = conn.prepareStatement("update room_table set room_img=?, intro=? where num=?");
				pstmt.setString(1, dto.getRoom_img());
				pstmt.setString(2, dto.getIntro());
				pstmt.setInt(3, roomnum);
				int res = pstmt.executeUpdate();
				if(res == 1) {
					chk = true;
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs!=null){try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return chk;
	}
	
	// reservationCalendar 페이지에서 달력에 표시하기 위해 방 이름값을 가져오는 메서드.  
	public List getRoomList() {
		List list = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select rname from room_table");
			rs = pstmt.executeQuery();
			list = new ArrayList();
			while(rs.next()) {
				list.add(rs.getString("rname"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs!=null){try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return list;
	}
	
	// 메서드 오버로딩
	// 위에서 있는 getRoomData와 같은 기능을 하는 메서드이지만, 매개변수가 다르다
	public RoomDTO getRoomData(String rname) {
		RoomDTO dto = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from room_table where rname=?");
			pstmt.setString(1, rname);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dto = new RoomDTO();
				dto.setNum(rs.getInt("num"));
				dto.setRname(rs.getString("rname"));
				dto.setDpeople(rs.getInt("dpeople"));
				dto.setMaxpeople(rs.getInt("maxpeople"));
				dto.setAddtionalcost(rs.getInt("addtionalcost"));
				dto.setWeekday_price(rs.getInt("weekday_price"));
				dto.setWeekend_price(rs.getInt("weekend_price"));
				dto.setPeakseason_price(rs.getInt("peakseason_price"));
				dto.setRoom_img(rs.getString("room_img"));
				dto.setIntro(rs.getString("intro"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			if(rs!=null){try {rs.close();}catch(SQLException s) {s.printStackTrace();}}
			if(pstmt!=null){try {pstmt.close();}catch(SQLException s) {s.printStackTrace();}}
			if(conn!=null){try {conn.close();}catch(SQLException s) {s.printStackTrace();}}
		}
		return dto;
	}
	

}
