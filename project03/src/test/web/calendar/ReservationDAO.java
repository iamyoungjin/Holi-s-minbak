package test.web.calendar;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import test.web.project03.AccountingVO;

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
		
		//  당일 해당하는 방 가져오기(check만 )
		// 19/10/31 18:30 메서드 변경(list에 DTO를 담지 않고, 그냥 String 변수 담는다)
		public List roomtodaycheck(String startday, String endday) {
			List list = new ArrayList();
			try {
				conn = getConnection();
				
				//체크아웃 고려 마지막날은 지움 
				String sql="select roomname from reservation_table where startday<=? AND endday>? AND chkpayment='check'" ;
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, startday);
				pstmt.setString(2, endday);
				rs = pstmt.executeQuery();
				//달을 넘기면 rs 에 들어오는 값이 왜 없는가 
				while(rs.next()) {
					list.add(rs.getString("roomname"));
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
		
		//당일 해당하는방 가져오기 ('waiting'만) 위 함수와 같이 쓰면 에러나서 따로 뺌 
		public List roomtodaywaiting(String startday, String endday) {
			List list = new ArrayList();
			try {
				conn = getConnection();
				
				//체크아웃 고려 마지막날은 지움 
				String sql="select roomname from reservation_table where startday<=? AND endday>? AND chkpayment='waiting'" ;
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, startday);
				pstmt.setString(2, endday);
				rs = pstmt.executeQuery();
				//달을 넘기면 rs 에 들어오는 값이 왜 없는가 
				while(rs.next()) {
					list.add(rs.getString("roomname"));
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
		public void paycheck(int roomnumber,String re_name){
			try {
				conn = getConnection();
				String sql="update reservation_table set chkpayment='check' where roomnumber=? and re_name =?  and chkpayment= 'waiting'";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, roomnumber);
				pstmt.setString(2, re_name);
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
		
		//마이페이지에서 지우는 함수
				// 19/10/31 18:30 오타 수정 및 취소일 기록
				public int cancelReservation(String re_id, int roomnumber, String currentTime){
					int res = 0;
					try {
						conn = getConnection();
						pstmt = conn.prepareStatement("select * from reservation_table where re_id=? and roomnumber=? ");
						pstmt.setString(1, re_id);
						pstmt.setInt(2, roomnumber);
						rs = pstmt.executeQuery();
						if(rs.next()) {
							String sDay = rs.getString("startday") +" 00:00";
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
							long dif = sdf.parse(sDay).getTime() - sdf.parse(currentTime).getTime();
							dif /= (60*1000);
							
							if(dif>1440) {
								int x = 0;
								if(rs.getString("chkpayment").equals("waiting")) {
									pstmt = conn.prepareStatement("update reservation_table set cancel_date=sysdate, chkpayment='cancel' where re_id=? and roomnumber=?");
									pstmt.setString(1, re_id);
									pstmt.setInt(2, roomnumber);
									x = pstmt.executeUpdate();
								}else if(rs.getString("chkpayment").equals("check")) {
									pstmt = conn.prepareStatement("update reservation_table set cancel_date=sysdate, chkpayment='refund' where re_id=? and roomnumber=?");
									pstmt.setString(1, re_id);
									pstmt.setInt(2, roomnumber);
									x = pstmt.executeUpdate();
								}
								if(x==1){
									res = 1;
									// 성공적으로 지워짐
								}else{
									res = 0;
									// 삭제 실패(쿼리 작동 에러)
								}
							}else{
								res = 2;
								// dif (예약취소시간과 예약일의 차이)가 1440(1일) 보다 크면 취소 불가
							}
						}
					}catch(Exception e){
						e.printStackTrace();
					}finally {
						if(rs != null) try {rs.close();}catch(SQLException e) {}
						if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
						if(conn != null) try {conn.close();}catch(SQLException e) {}
					}
					return res;
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
		
		//예약 퇴실날짜 가져오는 함수
		public List leavetoday_list(String today){
			List list = new ArrayList();
			
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
		
		

		//달 별 건수 가져오기
		//오늘 예약 건수 가져오기
		public List countchkmonth(String month,String val){
			List list = new ArrayList();
			try {
			conn = getConnection();
			String sql= "select * from reservation_table where to_char(reg_date, 'yyyy/MM/dd')  IN (select to_char(reg_date, 'yyyy/MM/dd') day from reservation_table where to_char(reg_date,'yyyy/MM') = ? and chkpayment=?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, month);
			pstmt.setString(2, val);
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
		
		//오늘 예약 건수 가져오기
		public List countchktoday(String today,String val){
			List list = new ArrayList();
			try {
			conn = getConnection();
			String sql= "select * from reservation_table where to_char(reg_date, 'yyyy/MM/dd')  IN (select to_char(reg_date, 'yyyy/MM/dd') day from reservation_table where to_char(reg_date,'yyyy/MM/dd') = ? and chkpayment=?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, today);
			pstmt.setString(2, val);
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
		
		//오늘 예약 취소 가져오기 
		public List countcanceltoday(String today,String val){
			List list = new ArrayList();
			try {
			conn = getConnection();
			String sql= "select * from reservation_table where to_char(cancel_date, 'yyyy/MM/dd')  IN (select to_char(cancel_date, 'yyyy/MM/dd') day from reservation_table where to_char(cancel_date,'yyyy/MM/dd') = ? and chkpayment=?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, today);
			pstmt.setString(2, val);
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
		// 예약 취소를 검사하기 위한 메서드. 1일시 마이페이지-예약페이지에서 [예약취소] 가 생긴다.
		public int checkCanclePossible(ReservationVO vo) {
			int chk = 0;
			try {
				String type = vo.getChkpayment();
				String endday = vo.getEndday();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
				Date currentday = new Date();
				Date eday = sdf.parse(endday);
				int compare = currentday.compareTo(eday);
				if(type.equals("waiting")) {
					chk = 1;
				}else if(type.equals("check")) {
					if(compare<0){
						chk = 1;
					}
				}else {
					chk = 0;
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return chk;
		}
		
		
		//강제 삭제 = paycancel 
		public void remove(int roomnumber, String re_name){
			try {
				conn = getConnection();
				String sql="delete from reservation_table where roomnumber =? and re_name=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, roomnumber);		
				System.out.println(roomnumber);
				pstmt.setString(2, re_name);				
				pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
		}
		
		// 카카오페이 api 사용을 위한 메서드
		// DAO의 payCheck 메서드를 사용하기 위함 + 카카오 페이로 예약한 유저의 데이터 값을 뽑아오기 위함
		// 가능하면 더 좋은 방법으로 사용해야함.
		public int getReservationNum(ReservationVO vo){
			int x = 0;
			try {
				conn = getConnection();
				String sql = "select roomnumber from reservation_table where "
						+ "re_id=? and re_name=? and daterange=? and roomname=? order by reg_date desc";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, vo.getRe_id());
				pstmt.setString(2, vo.getRe_name());
				pstmt.setString(3, vo.getDaterange());
				pstmt.setString(4, vo.getRoomname());
				rs = pstmt.executeQuery();
				if(rs.next()) {
					x = rs.getInt("roomnumber");
				}
			}catch(Exception e) {
				
			}finally {
				if(rs != null) try {rs.close();}catch(SQLException e) {}
				if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
				if(conn != null) try {conn.close();}catch(SQLException e) {}
			}
			return x;
		}
		
		// chkpayment을 받아오는 함수. chkpayment의 값에 따라 int 값 리턴 한다
				public int getChkpayment(int roomnumber) {
					int x=0;
					try {
						conn = getConnection();
						pstmt = conn.prepareStatement("select chkpayment from reservation_table where roomnumber=?");
						pstmt.setInt(1, roomnumber);
						rs = pstmt.executeQuery();
						if(rs.next()) {
							String chkpayment = rs.getString("chkpayment");
							if(chkpayment.equals("check")) {
								x = 1;
							}else if(chkpayment.equals("waiting")) {
								x = 2;
							}else if(chkpayment.equals("refund")) {
								x = 3;
							}else if(chkpayment.equals("cancle")) {
								x = 4;
							}
						}
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(rs != null) try {rs.close();}catch(SQLException e) {}
						if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
						if(conn != null) try {conn.close();}catch(SQLException e) {}
					}
					
					return x;
				}
				
				// admin이 취소(삭제말고 취소)
				public int cancelRsv(int roomnumber, String re_name) {
					int x = 0;
					try {
						conn = getConnection();
						pstmt = conn.prepareStatement("select * from reservation_table where roomnumber=? and re_name=?");
						pstmt.setInt(1, roomnumber);
						pstmt.setString(2, re_name);
						rs = pstmt.executeQuery();
						if(rs.next()){
							pstmt = conn.prepareStatement("update reservation_table set chkpayment='cancel' where roomnumber=? and re_name=? and chkpayment='waiting'");
							pstmt.setInt(1, roomnumber);
							pstmt.setString(2, re_name);
							int res = pstmt.executeUpdate();
							if(res>0) {
								x=1;
							}
						}
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(rs != null) try {rs.close();}catch(SQLException e) {}
						if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
						if(conn != null) try {conn.close();}catch(SQLException e) {}
					}
					return x;
					
				}
				
				// admin이 refund상태에서 확인하고 취소할수있게함
				public int refundRsv(int roomnumber, String re_name) {
					int x =0;
					try {
						conn = getConnection();
						pstmt = conn.prepareStatement("select * from reservation_table where roomnumber=? and re_name=?");
						pstmt.setInt(1, roomnumber);
						pstmt.setString(2, re_name);
						rs = pstmt.executeQuery();
						if(rs.next()){
							pstmt = conn.prepareStatement("update reservation_table set chkpayment='cancel' where roomnumber=? and re_name=? and chkpayment='refund'");
							pstmt.setInt(1, roomnumber);
							pstmt.setString(2, re_name);
							int res = pstmt.executeUpdate();
							if(res>0) {
								x=1;
							}
						}			
					}catch(Exception e) {
						e.printStackTrace();
					}finally {
						if(rs != null) try {rs.close();}catch(SQLException e) {}
						if(pstmt != null) try {pstmt.close();}catch(SQLException e) {}
						if(conn != null) try {conn.close();}catch(SQLException e) {}
					}
					return x;
				}
}
