package test.web.usertype;

public class UsertypeDTO {
	// member_table 의 user_type(숫자) 에 대한 설명을 꺼내오기 위한 빈즈
	
	private int user_type;
	private String status;
	public int getUser_type() {
		return user_type;
	}
	public void setUser_type(int user_type) {
		this.user_type = user_type;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
}
