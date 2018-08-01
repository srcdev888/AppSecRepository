package com.concretepage.village;
public class Village {
	private Integer id;
	private String name;
	private String district;
	private String country;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDistrict() {
		return district;
	}
	public void setDistrict(String district) {
		this.district = district;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	
	@Override
	public String toString() {
		StringBuffer buffer = new StringBuffer();
		buffer.append("id: ").append(getId());
		buffer.append(", Name: ").append(getName());
		buffer.append(", District: ").append(getDistrict());
		buffer.append(", Country: ").append(getCountry());
		return buffer.toString();
	}
}
