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
		
		
		
		//방 중복 예약 체크 (다시)
		public boolean roomchk(String startday, String endday, String rname) {
			boolean chk =false;
			ReservationVO vo = new ReservationVO();
			List list = new ArrayList();
			List <String>arr = new ArrayList<>();
			String sql = null;
			try {
				conn = getConnection();
				arr = vo.middate(startday,endday);
				for(int i=0;i<arr.size();i++) {
					sql = "select roomname from reservation_table where startday<=? and endday>?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1,arr.get(i));
					pstmt.setString(2,arr.get(i));
					rs=pstmt.executeQuery();
					while(rs.next()){
						String rn = rs.getString("roomname");
						list.add(rn);
					}
					for(int q =0;q<list.size();q++) {
						String k=list.get(q).toString();
						if(k.equals(rname)) {
							chk=true;
							break;
						}
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
				//pstmt.setInt(4, roomnumber);	
				pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
		}
			
		
		//예약정보 전체 출력 (방이름 /예약아이디/예약자명/사용인원/가격/기간/ 몇박/시작날/끝나는날/등록날짜/결제방식/결제유무
		public List reservation_list(){
			List list = new ArrayList();
			try {
				conn = getConnection();
				String sql = "select * from reservation_table ";
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();

				while(rs.next()) {
					ReservationVO vo = new ReservationVO();
					vo.setRoomnumber(rs.getInt("roomnumber"));
					vo.setRoomname(rs.getString("roomname"));
					vo.setRe_id(rs.getString("re_id"));	
					vo.setRe_name(rs.getString("re_name"));	
					vo.setRe_email(rs.getString("re_email"));
					vo.setRe_phone(rs.getString("re_phone"));
					vo.setUsepeople(rs.getInt("usepeople"));	
					vo.setPrice(rs.getInt("price"));	
					vo.setDaterange(rs.getString("daterange"));	
					vo.setUsingday(rs.getInt("usingday"));
					vo.setStartday(rs.getString("startday"));
					vo.setEndday(rs.getString("endday"));
					vo.setReg_date(rs.getTimestamp("reg_date"));
					vo.setPaymentmethod(rs.getString("paymentmethod"));
					vo.setChkpayment(rs.getString("chkpayment"));
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
		

		public List reservation_user(String sId) {
			List list = null;
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement("select * from reservation_table where re_id=? order by reg_date desc");
				pstmt.setString(1, sId);
				rs = pstmt.executeQuery();
				list = new ArrayList();
				while(rs.next()) {
					ReservationVO vo = new ReservationVO();
					vo.setRoomnumber(rs.getInt("roomnumber"));
					vo.setRoomname(rs.getString("roomname"));
					vo.setRe_id(rs.getString("re_id"));	
					vo.setRe_name(rs.getString("re_name"));	
					vo.setRe_email(rs.getString("re_email"));
					vo.setRe_phone(rs.getString("re_phone"));
					vo.setUsepeople(rs.getInt("usepeople"));	
					vo.setPrice(rs.getInt("price"));	
					vo.setDaterange(rs.getString("daterange"));	
					vo.setUsingday(rs.getInt("usingday"));
					vo.setStartday(rs.getString("startday"));
					vo.setEndday(rs.getString("endday"));
					vo.setReg_date(rs.getTimestamp("reg_date"));
					vo.setPaymentmethod(rs.getString("paymentmethod"));
					vo.setChkpayment(rs.getString("chkpayment"));
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
		
		//마이페이지에서 지우는 함
		public boolean cancleReservation(String re_id, int roomnumber){
			boolean chk = false;
			try {
				conn = getConnection();
				pstmt = conn.prepareStatement("select * from reservation_table where re_id=? and roomnumber=? ");
				pstmt.setString(1, re_id);
				pstmt.setInt(2, roomnumber);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					pstmt = conn.prepareStatement("delete from reservation_table where re_id=? and roomnumber=?");
					pstmt.setString(1, re_id);
					pstmt.setInt(2, roomnumber);
					int x = pstmt.executeUpdate();
					if(x==1){
						chk=true;
					}
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
			return chk;
		}		
		
		//예약 정보 서치 
		public List reservation_search(String method, String val){
			List list = new ArrayList();
			String text= "select * from reservation_table where "+method;
			try {
				conn = getConnection();
				String sql = text+"="+ val;
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					ReservationVO vo = new ReservationVO();
					vo.setRoomnumber(rs.getInt("roomnumber"));
					vo.setRoomname(rs.getString("roomname"));
					vo.setRe_id(rs.getString("re_id"));
					vo.setRe_name(rs.getString("re_name"));
					vo.setRe_phone(rs.getString("re_phone"));
					vo.setRe_email(rs.getString("re_email"));
					vo.setUsepeople(rs.getInt("usepeople"));
					vo.setRoomname(rs.getString("roomname"));
					vo.setPrice(rs.getInt("price"));
					vo.setDaterange(rs.getString("daterange"));
					vo.setUsingday(rs.getInt("usingday"));
					vo.setStartday(rs.getString("startday"));
					vo.setEndday(rs.getString("endday"));
					vo.setPaymentmethod(rs.getString("paymentmethod"));
					vo.setChkpayment(rs.getString("chkpayment"));
					vo.setReg_date(rs.getTimestamp("reg_date"));
					
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
		
		//오늘 예약 입실자 현황 보여주기
		public List cometoday_list(String today){
			List list = new ArrayList();
			System.out.println(today);
			try {
				conn = getConnection();
				String sql = "select * from reservation_table where startday= ? and chkpayment = 'check'";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, today);
				rs = pstmt.executeQuery();

				while(rs.next()) {
					ReservationVO vo = new ReservationVO();
					vo.setRoomnumber(rs.getInt("roomnumber"));
					vo.setRoomname(rs.getString("roomname"));
					vo.setRe_id(rs.getString("re_id"));	
					vo.setRe_name(rs.getString("re_name"));	
					vo.setRe_email(rs.getString("re_email"));
					vo.setRe_phone(rs.getString("re_phone"));
					vo.setUsepeople(rs.getInt("usepeople"));	
					vo.setPrice(rs.getInt("price"));	
					vo.setDaterange(rs.getString("daterange"));	
					vo.setUsingday(rs.getInt("usingday"));
					vo.setStartday(rs.getString("startday"));
					vo.setEndday(rs.getString("endday"));
					vo.setReg_date(rs.getTimestamp("reg_date"));
					vo.setPaymentmethod(rs.getString("paymentmethod"));
					vo.setChkpayment(rs.getString("chkpayment"));
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
		
		public List leavetoday_list(String today){
			List list = new ArrayList();
			System.out.println(today);
			try {
				conn = getConnection();
				String sql = "select * from reservation_table where endday= ? and chkpayment = 'check'";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, today);
				rs = pstmt.executeQuery();

				while(rs.next()) {
					ReservationVO vo = new ReservationVO();
					vo.setRoomnumber(rs.getInt("roomnumber"));
					vo.setRoomname(rs.getString("roomname"));
					vo.setRe_id(rs.getString("re_id"));	
					vo.setRe_name(rs.getString("re_name"));	
					vo.setRe_email(rs.getString("re_email"));
					vo.setRe_phone(rs.getString("re_phone"));
					vo.setUsepeople(rs.getInt("usepeople"));	
					vo.setPrice(rs.getInt("price"));	
					vo.setDaterange(rs.getString("daterange"));	
					vo.setUsingday(rs.getInt("usingday"));
					vo.setStartday(rs.getString("startday"));
					vo.setEndday(rs.getString("endday"));
					vo.setReg_date(rs.getTimestamp("reg_date"));
					vo.setPaymentmethod(rs.getString("paymentmethod"));
					vo.setChkpayment(rs.getString("chkpayment"));
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
}
