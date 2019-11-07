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
	
	public boolean insertRoom(RoomDTO dto) {
		boolean chk = true;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from room_table where rname=?");
			pstmt.setString(1, dto.getRname());
			rs = pstmt.executeQuery();
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
	
	public void deleteRoom(RoomDTO dto) {
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from room_table where num=?");
			pstmt.setInt(1, dto.getNum());
			rs= pstmt.executeQuery();
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
	
	public boolean updateIntro(int roomnum, RoomDTO dto) {
		boolean chk = false;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement("select * from room_table where num=?");
			pstmt.setInt(1, roomnum);
			rs = pstmt.executeQuery();
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
