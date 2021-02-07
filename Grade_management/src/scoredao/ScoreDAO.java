package scoredao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import scoreVO.ScoreVO;

public class ScoreDAO {
	
	private static ScoreDAO sDAO;
	
	private ScoreDAO() {}

	public static ScoreDAO getInstance() {
		if(sDAO == null) {
			sDAO = new ScoreDAO();
		}//end if
		return sDAO;
	}//getInstance
	
	public Connection getConnection() throws SQLException{
		try {
			Class.forName("oracle.jdbc.OracleDriver");
		}catch(ClassNotFoundException e) {
			e.printStackTrace();
		}
		String url = "jdbc:oracle:thin:@localhost:1521:orcl";
		String user = "scott";
		String password = "tiger";
		return DriverManager.getConnection(url, user, password);
	}
	
	public List<ScoreVO> selectAll() {
		List<ScoreVO> list = new ArrayList<>();
		String sql = "SELECT * FROM SCORE ORDER BY NAME ASC";
		try(Connection con = sDAO.getConnection();
			PreparedStatement pstmt = con.prepareStatement(sql);
			ResultSet rs = pstmt.executeQuery()){
			ScoreVO sVO = null;
			while(rs.next()) {
				sVO = new ScoreVO(rs.getString("NAME"),
					rs.getInt("KOREA"), rs.getInt("MATH"),
					rs.getInt("ENGLISH"), rs.getInt("TOTAL"),
					rs.getInt("AVERAGE"));
				list.add(sVO);
			}
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}//select All
	
	public int insertScore(ScoreVO sVO) {
		int flag = -1;
		String sql = "INSERT INTO SCORE VALUES (?,?,?,?,?,?)";
		
		try(Connection con = sDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
			pstmt.setString(1, sVO.getName());
			pstmt.setInt(2, sVO.getKorea());
			pstmt.setInt(3, sVO.getMath());
			pstmt.setInt(4, sVO.getEnglish());
			pstmt.setInt(5, sVO.getTotal());
			pstmt.setInt(6, sVO.getAverage());
			flag = pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//insertScore
	
	public int updateScore(ScoreVO sVO) {
		int flag = -1;
		String sql = "UPDATE SCORE SET KOREA=?, MATH=?, ENGLISH=?,TOTAL=?,AVERAGE=? WHERE NAME=?";
		try(Connection con = sDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
			pstmt.setInt(1, sVO.getKorea());
			pstmt.setInt(2, sVO.getMath());
			pstmt.setInt(3, sVO.getEnglish());
			pstmt.setInt(4, sVO.getTotal());
			pstmt.setInt(5, sVO.getAverage());
			pstmt.setString(6, sVO.getName());
			flag = pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}//end catch
		return flag;
	}//updateScore
	
	
	public int deleteScore(String name) {
		int flag = -1;
		String sql="DELETE FROM SCORE WHERE NAME = ?";
		try(Connection con = sDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
			pstmt.setString(1, name);
			flag = pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}//end catch
		return flag;
	}//deleteScore
	
}
