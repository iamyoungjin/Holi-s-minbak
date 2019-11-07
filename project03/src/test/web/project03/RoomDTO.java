package test.web.project03;

public class RoomDTO {
	private int num;
	private String rname;
	private int dpeople;
	private int maxpeople;
	private int addtionalcost;
	private int weekday_price;
	private int weekend_price;
	private int peakseason_price;
	private String room_img;
	private String intro;
	
	public String getRoom_img() {
		return room_img;
	}
	public void setRoom_img(String room_img) {
		this.room_img = room_img;
	}
	public String getIntro() {
		return intro;
	}
	public void setIntro(String intro) {
		this.intro = intro;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getRname() {
		return rname;
	}
	public void setRname(String rname) {
		this.rname = rname;
	}
	
	public int getDpeople() {
		return dpeople;
	}
	public void setDpeople(int dpeople) {
		this.dpeople = dpeople;
	}
	public int getMaxpeople() {
		return maxpeople;
	}
	public void setMaxpeople(int maxpeople) {
		this.maxpeople = maxpeople;
	}
	public int getAddtionalcost() {
		return addtionalcost;
	}
	public void setAddtionalcost(int addtionalcost) {
		this.addtionalcost = addtionalcost;
	}
	public int getWeekday_price() {
		return weekday_price;
	}
	public void setWeekday_price(int weekday_price) {
		this.weekday_price = weekday_price;
	}
	public int getWeekend_price() {
		return weekend_price;
	}
	public void setWeekend_price(int weekend_price) {
		this.weekend_price = weekend_price;
	}
	public int getPeakseason_price() {
		return peakseason_price;
	}
	public void setPeakseason_price(int peakseason_price) {
		this.peakseason_price = peakseason_price;
	}
	

}
