package test.web.calendar;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ReservationDAO {
		private Connection conn = null;
		private PreparedStatement pstmt = null;
		private ResultSet rs = null;
		
		private Connection getConnection() throws Exception{
			Context initCtx = new InitialContext();	
			Context envCtx =(Context)initCtx.lookup("java:comp/env");
			DataSource ds = (DataSource)envCtx.lookup("jdbc/xe");
			return ds.getConnection();
		}
		
		//예약 
		public void reservation(ReservationVO vo) {
			try {
				conn = getConnection();
				String sql = "insert into reservation_table(roomnumber,re_id,re_name,re_phone,re_email,daterange,roomname,usepeople,price,paymentmethod,chkpayment,reg_date,year,month,day,usingday,startday,endday) values(reservation_table_seq.nextval,?,?,?,?,?,?,?,?,?,?,sysdate,?,?,?,?,?,?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, vo.getRe_id());
				pstmt.setString(2, vo.getRe_name());
				pstmt.setString(3, vo.getRe_phone());
				pstmt.setString(4, vo.getRe_email());
				pstmt.setString(5, vo.getDaterange());
				pstmt.setString(6, vo.getRoomname());
				pstmt.setInt(7, vo.getUsepeople());
				pstmt.setInt(8, vo.getPrice());
				pstmt.setString(9, vo.getPaymentmethod());
				pstmt.setString(10, vo.getChkpayment());
				pstmt.setInt(11, vo.getYear());
				pstmt.setInt(12, vo.getMonth());
				pstmt.setInt(13, vo.getDay());
				pstmt.setInt(14, vo.getUsingday());
				pstmt.setString(15, vo.getStartday());
				pstmt.setString(16, vo.getEndday());
				pstmt.executeUpdate();
				
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
		}
		
		//룸네임 전체 출력 
		public List list(){
			List list = new ArrayList();
			try {
				conn = getConnection();
				String sql = "select roomname from reservation_table ";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					ReservationVO vo = new ReservationVO();
					vo.setRoomname(rs.getString("roomname"));				
					list.add(vo);
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
			return list;
		}
		
		//날짜를 쪼개기 위해 daterange가져오기 
		public List daterange() {
			List list = new ArrayList();
			try {
				conn = getConnection();
				String sql = "select distinct daterange from reservation_table";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					ReservationVO vo = new ReservationVO();
					vo.setDaterange(rs.getString("daterange"));				
					list.add(vo);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
				return list;
		}
		
		//  당일 해당하는 방 가져오기  
		public List roomtoday(String startday, String endday) {
			List list = new ArrayList();
			try {
				conn = getConnection();
				
				//체크아웃 고려 마지막날은 지움 
				String sql="select roomname from reservation_table where startday<=? AND endday>? AND chkpayment='check'";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, startday);
				pstmt.setString(2, endday);
				rs = pstmt.executeQuery();
				//달을 넘기면 rs 에 들어오는 값이 왜 없는가 
				while(rs.next()) {
					ReservationVO vo = new ReservationVO();
					vo.setRoomname(rs.getString("roomname"));
					list.add(vo);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
			return list;
		}
		
		// 평일 방 가격 가져오기 
		public int roomprice_weekday(String rname) {
			int roomprice= 0;
			Calendar c = Calendar.getInstance();
			try {
					conn = getConnection();
					String sql = "select weekday_price from room_table where rname=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, rname);
					rs = pstmt.executeQuery();
					while(rs.next()) {
						roomprice = rs.getInt("weekday_price");
					}		
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
			return roomprice;
		}
		
		// 주말 방 가격 가져오기 
		public int roomprice_weekend(String rname) {
			int roomprice= 0;
			Calendar c = Calendar.getInstance();
			try {
					conn = getConnection();
					String sql = "select weekend_price from room_table where rname=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, rname);
					rs = pstmt.executeQuery();
					while(rs.next()) {
						roomprice = rs.getInt("weekend_price");
					}		
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
			return roomprice;
		}
		
		
		// 성수기 방 가격 가져오기 
		public int roomprice_peakseason(String rname) {
			int roomprice= 0;
			Calendar c = Calendar.getInstance();
			try {
					conn = getConnection();
					String sql = "select peakseason_price from room_table where rname=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, rname);
					rs = pstmt.executeQuery();
					while(rs.next()) {
						roomprice = rs.getInt("peakseason_price");
					}		
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
			return roomprice;
		}
		
		
		
		//방 중복 예약 체크 
		public boolean roomchk(String startday, String endday, String rname) {
			boolean chk =false;
			List list = new ArrayList();
			try {
				conn = getConnection();

				String sql="select roomname from reservation_table where startday<=? and endday>?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, startday);
				pstmt.setString(2, endday);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					String rn = (rs.getString("roomname"));		
					list.add(rn);
				}
				for(int j=0;j<list.size();j++) {
					System.out.println(list.get(j));
					System.out.println(rname);
					if(list.get(j).toString().equals(rname)) { //형변환 주의 
						chk=true;
					}	
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
			return chk;
		}
		
		//결제된 예약 체크 표시하기 
		public void paycheck(String re_name, String re_phone, String roomname){
			try {
				conn = getConnection();
				String sql="update reservation_table set chkpayment='check' where re_name =? and re_phone=? and roomname=? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, re_name);
				pstmt.setString(2, re_phone);
				pstmt.setString(3, roomname);
				pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
		}
		//결제 취소된 예약 삭제하기 
		public void paycancel(String re_name, String re_phone, String roomname){
			try {
				conn = getConnection();
				String sql="delete from reservation_table where re_name =? and re_phone=? and roomname=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, re_name);
				pstmt.setString(2, re_phone);
				pstmt.setString(3, roomname);
				pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
		}
			


		
}
