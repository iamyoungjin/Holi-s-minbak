package test.web.project03;
import java.util.*;
import java.util.Date;
import java.util.Calendar;
import test.web.project03.RoomDTO;
import java.util.List;
import test.web.project03.RoomDAO;
import test.web.project03.AccountingDAO;
import test.web.calendar.ReservationVO;
import test.web.calendar.ReservationDAO;
public class AccountingVO {
	public int room_totprice(String yearmonth,String roomname){
		Calendar cc = Calendar.getInstance();
		int rp=0;
		List lst2 = new ArrayList();
		AccountingDAO dao = new AccountingDAO();
		lst2 = dao.room_month_income(yearmonth,roomname);
		//st2 = dao.room_month_income(cc.get(Calendar.YEAR),(cc.get(Calendar.MONTH)+1),rname);
		for(int i=0;i<lst2.size();i++){
			rp+=Integer.parseInt(lst2.get(i).toString());
			}
		return rp;
		}
	
	public int getRoom1_M_income() {
		return Room1_M_income;
	}
	public void setRoom1_M_income(int room1_M_income) {
		Room1_M_income = room1_M_income;
	}
	public int getRoom1_W_income() {
		return Room1_W_income;
	}
	public void setRoom1_W_income(int room1_W_income) {
		Room1_W_income = room1_W_income;
	}
	public int getRoom2_M_income() {
		return Room2_M_income;
	}
	public void setRoom2_M_income(int room2_M_income) {
		Room2_M_income = room2_M_income;
	}
	public int getRoom2_W_income() {
		return Room2_W_income;
	}
	public void setRoom2_W_income(int room2_W_income) {
		Room2_W_income = room2_W_income;
	}
	public int getRoom3_M_income() {
		return Room3_M_income;
	}
	public void setRoom3_M_income(int room3_M_income) {
		Room3_M_income = room3_M_income;
	}
	public int getRoom3_W_income() {
		return Room3_W_income;
	}
	public void setRoom3_W_income(int room3_W_income) {
		Room3_W_income = room3_W_income;
	}
	public int getRoom4_M_income() {
		return Room4_M_income;
	}
	public void setRoom4_M_income(int room4_M_income) {
		Room4_M_income = room4_M_income;
	}
	public int getRoom4_W_income() {
		return Room4_W_income;
	}
	public void setRoom4_W_income(int room4_W_income) {
		Room4_W_income = room4_W_income;
	}
	public int getRoom5_M_income() {
		return Room5_M_income;
	}
	public void setRoom5_M_income(int room5_M_income) {
		Room5_M_income = room5_M_income;
	}
	public int getRoom5_W_income() {
		return Room5_W_income;
	}
	public void setRoom5_W_income(int room5_W_income) {
		Room5_W_income = room5_W_income;
	}
	public int getRoom6_M_income() {
		return Room6_M_income;
	}
	public void setRoom6_M_income(int room6_M_income) {
		Room6_M_income = room6_M_income;
	}
	public int getRoom6_w_income() {
		return Room6_w_income;
	}
	public void setRoom6_w_income(int room6_w_income) {
		Room6_w_income = room6_w_income;
	}
		
		public String getRe_id() {
			return re_id;
		}



		public void setRe_id(String re_id) {
			this.re_id = re_id;
		}



		public int getCnt() {
			return cnt;
		}



		public void setCnt(int cnt) {
			this.cnt = cnt;
		}

		
		private int Room1_M_income;
		private int Room1_W_income;
		private int Room2_M_income;
		private int Room2_W_income;
		private int Room3_M_income;
		private int Room3_W_income;
		private int Room4_M_income;
		private int Room4_W_income;
		private int Room5_M_income;
		private int Room5_W_income;
		private int Room6_M_income;
		private int Room6_w_income;
		private String re_id;
		private int cnt;
}
