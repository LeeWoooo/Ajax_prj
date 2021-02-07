package scoreVO;

public class ScoreVO {
	
	private String name;
	private int korea;
	private int	math;
	private int english;
	private int	total;
	private int	average;
	
	public ScoreVO(String name, int korea, int math, int english, int total, int average) {
		super();
		this.name = name;
		this.korea = korea;
		this.math = math;
		this.english = english;
		this.total = total;
		this.average = average;
	}

	public ScoreVO() {
		super();
	}

	public String getName() {
		return name;
	}

	public int getKorea() {
		return korea;
	}

	public int getMath() {
		return math;
	}

	public int getEnglish() {
		return english;
	}

	public int getTotal() {
		return total;
	}

	public int getAverage() {
		return average;
	}
	
}
