package test.web.calendar;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
public class ReservationVO {
	
	// 날짜 설정 
	public boolean isDate(int y, int m, int d) {
		boolean t = false;
		m -= 1;
		Calendar c = Calendar.getInstance(); //현재 날짜와 시간 정보를 가진캘린더 객체 생성 
		//c.setLenient(false);// true(디폴트)이면 get, add, roll 메소드에서 시각필드값이 허용범위를 벗어나도 다른 시각필드를 재조정하나 false이면 예외가 발생한다.
		c.set(y,m,d);
		if(d<=c.get(Calendar.DAY_OF_MONTH))
			t = c.isLenient();
		//try {
		//	c.set(y,m,d);
		//	t = c.isLenient();
		//}catch(Exception e) {
		//e.printStackTrace();//return false;
		//}
		return t;
	}
	
	//캘린더 타이틀가져오기 
	public String  getTitle(Calendar cal){
		//simpleDateFormat : 해당 패턴으로 포맷을 변경할 수 있음.
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM");
		return sdf.format(cal.getTime()); //입력받은 캘린더 객체의타이틀을 위의 포멧으로 변경  
	}
	
	//특정 요일 가져오기 
	public String getday(String dr) throws Exception{
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
	 
	 Date date = formatter.parse(dr);  // 날짜 입력하는곳 .
	 date = new Date(date.getTime() + (1000*60*60*24*+1)-1);  // 날짜에 하루를 더한 값 
	 // 하루를 뺄려면 (1000*60*60*24*-1)
	 
	 Calendar cal = Calendar.getInstance() ;
	 cal.setTime(date);              // 하루더한 날자 값을 Calendar  넣는다.
	 
	 int dayNum = cal.get(Calendar.DAY_OF_WEEK);   // 요일을 구해온다. 
	 
	 String convertedString = "";
	 
	 switch (dayNum ) {
	     case 1: convertedString = "일"; break;
	     case 2: convertedString = "월"; break;
	     case 3: convertedString = "화"; break;
	     case 4: convertedString = "수"; break;
	     case 5: convertedString = "목"; break;
	     case 6: convertedString = "금"; break;
	     case 7: convertedString = "토"; break;
	 }
	 return convertedString;
}
		
	//중간날짜 구해주는 함수 
	public List<String> middate(String startday, String endday) throws ParseException {
	    final String DATE_PATTERN = "yyyy/MM/dd";
	    String inputStartDate = startday;
	    String inputEndDate = endday;
	    SimpleDateFormat sdf = new SimpleDateFormat(DATE_PATTERN);
	    Date startDate = sdf.parse(inputStartDate);
	    Date endDate = sdf.parse(inputEndDate);
	    ArrayList<String> dates = new ArrayList<String>();
	    Date currentDate = startDate;
	    while (currentDate.compareTo(endDate) <= 0) {
	        dates.add(sdf.format(currentDate));
	        Calendar c = Calendar.getInstance();
	        c.setTime(currentDate);
	        c.add(Calendar.DAY_OF_MONTH, 1);
	        currentDate = c.getTime();
	    }
	    //for (String date : dates) {
	        return dates;
	    //}
	}
	
	
	
	private int roomnumber;
	private String re_id;
	private String re_name;
	private String re_phone;
	private String re_email;
	private String daterange;
	private String roomname;
	private int usepeople;
	private int price;
	private Timestamp reg_date;
	private String paymentmethod;
	private String chkpayment;
	private int year;
	private int month;
	private int day;
	private int usingday;
	private String startday;
	private String endday;
	private Timestamp cancel_date;
	
	
	public Timestamp getCancel_date() {
		return cancel_date;
	}

	public void setCancel_date(Timestamp cancel_date) {
		this.cancel_date = cancel_date;
	}

	public String getStartday() {
		return startday;
	}

	public void setStartday(String startday) {
		this.startday = startday;
	}

	public String getEndday() {
		return endday;
	}

	public void setEndday(String endday) {
		this.endday = endday;
	}

	
	public int getUsingday() {
		return usingday;
	}

	public void setUsingday(int usingday) {
		this.usingday = usingday;
	}



	
	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public int getMonth() {
		return month;
	}

	public void setMonth(int month) {
		this.month = month;
	}

	public int getDay() {
		return day;
	}

	public void setDay(int day) {
		this.day = day;
	}
	
		
	
	public int getRoomnumber() {
		return roomnumber;
	}

	public void setRoomnumber(int roomnumber) {
		this.roomnumber = roomnumber;
	}

	public String getRe_id() {
		return re_id;
	}

	public void setRe_id(String re_id) {
		this.re_id = re_id;
	}

	public String getRe_name() {
		return re_name;
	}

	public void setRe_name(String re_name) {
		this.re_name = re_name;
	}

	public String getRe_phone() {
		return re_phone;
	}

	public void setRe_phone(String re_phone) {
		this.re_phone = re_phone;
	}

	public String getRe_email() {
		return re_email;
	}

	public void setRe_email(String re_email) {
		this.re_email = re_email;
	}

	public String getDaterange() {
		return daterange;
	}

	public void setDaterange(String daterange) {
		this.daterange = daterange;
	}

	public String getRoomname() {
		return roomname;
	}

	public void setRoomname(String roomname) {
		this.roomname = roomname;
	}

	public int getUsepeople() {
		return usepeople;
	}

	public void setUsepeople(int usepeople) {
		this.usepeople = usepeople;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public Timestamp getReg_date() {
		return reg_date;
	}

	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}

	public String getPaymentmethod() {
		return paymentmethod;
	}

	public void setPaymentmethod(String paymentmethod) {
		this.paymentmethod = paymentmethod;
	}

	public String getChkpayment() {
		return chkpayment;
	}

	public void setChkpayment(String chkpayment) {
		this.chkpayment = chkpayment;
	}

}
