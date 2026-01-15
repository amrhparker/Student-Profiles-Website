package com.profileapp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    private final String DB_URL = "jdbc:derby://localhost:1527/student_profiles";
    private final String DB_USER = "yae";
    private final String DB_PASS = "yae";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        System.out.println("=== ProfileServlet.doPost() called ===");
        
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            updateProfile(request, response);
        } else {
            insertProfile(request, response);
        }
    }
    
    private void insertProfile(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        //retrieve form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String program = request.getParameter("program");
        String hobbies = request.getParameter("hobbies");
        String intro = request.getParameter("intro");
        String studID = request.getParameter("studID");

        System.out.println("Received form data:");
        System.out.println("Name: " + name);
        System.out.println("Student ID: " + studID);
        System.out.println("Email: " + email);
        
        if (!validateInput(name, email, studID)) {
            request.setAttribute("error", "Invalid input. Please check your data.");
            request.getRequestDispatcher("detailsPage.jsp").forward(request, response);
            return;
        }

        //check if student ID already exists
        if (studentIdExists(studID)) {
            request.setAttribute("error", "Student ID already exists. Please use a different ID.");
            request.getRequestDispatcher("detailsPage.jsp").forward(request, response);
            return;
        }

        //create profile
        ProfileBean profile = new ProfileBean();
        profile.setName(name);
        profile.setEmail(email);
        profile.setProgram(program);
        profile.setHobbies(hobbies);
        profile.setIntro(intro);
        profile.setStudID(studID);

        //insertion
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO profiles (name, email, program, hobbies, intro, studID) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, program);
            stmt.setString(4, hobbies);
            stmt.setString(5, intro);
            stmt.setString(6, studID);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int newId = generatedKeys.getInt(1);
                        profile.setId(newId);
                        System.out.println("Generated ID: " + newId);
                    }
                }
            }
            
            System.out.println("Insert successful!");
            
            //pass the profile to JSP
            request.setAttribute("profile", profile);
            request.setAttribute("message", "Profile created successfully!");
            request.getRequestDispatcher("profilePage.jsp").forward(request, response);
            
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found!");
            e.printStackTrace();
            throw new ServletException("JDBC Driver not found", e);
        } catch (SQLException e) {
            e.printStackTrace();  // Keep for debugging
            request.setAttribute("error", "A database error occurred. Please try again.");  // Generic message
        } catch (Exception e) {
            System.err.println("Unexpected error!");
            e.printStackTrace();
            throw new ServletException("Unexpected error", e);
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
                System.out.println("Database resources closed");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String program = request.getParameter("program");
        String hobbies = request.getParameter("hobbies");
        String intro = request.getParameter("intro");
        String studID = request.getParameter("studID");

        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            String sql = "UPDATE profiles SET name=?, email=?, program=?, hobbies=?, intro=?, studID=? WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, program);
            stmt.setString(4, hobbies);
            stmt.setString(5, intro);
            stmt.setString(6, studID);
            stmt.setInt(7, Integer.parseInt(id));
            
            stmt.executeUpdate();
            stmt.close();
            conn.close();
            
            //show updated profile
            ProfileBean profile = new ProfileBean();
            profile.setId(Integer.parseInt(id));
            profile.setName(name);
            profile.setEmail(email);
            profile.setProgram(program);
            profile.setHobbies(hobbies);
            profile.setIntro(intro);
            profile.setStudID(studID);
            
            request.setAttribute("profile", profile);
            request.setAttribute("message", "Profile updated!");
            request.getRequestDispatcher("profilePage.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Update failed");
            doGet(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        //handle view single profile
        if ("view".equals(action) && idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                ProfileBean profile = getProfileById(id);
                if (profile != null) {
                    request.setAttribute("profile", profile);
                    request.getRequestDispatcher("profilePage.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("error", "Profile not found");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("error", "Invalid profile ID");
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
        }
        
        //show edit form
        if ("edit".equals(action) && idParam != null) {
            try {
                ProfileBean profile = getProfileById(Integer.parseInt(idParam));
                if (profile != null) {
                    request.setAttribute("profile", profile);
                    request.getRequestDispatcher("editDetails.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        //deletion
        if ("delete".equals(action) && idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                boolean deleted = deleteProfileById(id);
                if (deleted) {
                    request.setAttribute("message", "Profile deleted successfully");
                } else {
                    request.setAttribute("error", "Failed to delete profile");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid profile ID");
            } catch (SQLException e) {
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
        }

        //Existing search/all profiles code
        ArrayList<ProfileBean> profilesList = new ArrayList<>();
        String searchName = request.getParameter("searchName");
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            String sql;
            PreparedStatement stmt;
            if (searchName != null && !searchName.trim().isEmpty()) {
                sql = "SELECT * FROM profiles WHERE name LIKE ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, "%" + searchName + "%");
            } else {
                sql = "SELECT * FROM profiles";
                stmt = conn.prepareStatement(sql);
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ProfileBean profile = new ProfileBean();
                profile.setId(rs.getInt("id"));
                profile.setName(rs.getString("name"));
                profile.setEmail(rs.getString("email"));
                profile.setProgram(rs.getString("program"));
                profile.setHobbies(rs.getString("hobbies"));
                profile.setIntro(rs.getString("intro"));
                profile.setStudID(rs.getString("studID"));

                profilesList.add(profile);
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading profiles: " + e.getMessage());
        }
        request.setAttribute("profilesList", profilesList);
        request.getRequestDispatcher("viewProfiles.jsp").forward(request, response);
    }

    private ProfileBean getProfileById(int id) throws SQLException {
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        String sql = "SELECT * FROM profiles WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, id);
        ResultSet rs = stmt.executeQuery();
        
        ProfileBean profile = null;
        if (rs.next()) {
            profile = new ProfileBean();
            profile.setId(rs.getInt("id"));
            profile.setName(rs.getString("name"));
            profile.setEmail(rs.getString("email"));
            profile.setProgram(rs.getString("program"));
            profile.setHobbies(rs.getString("hobbies"));
            profile.setIntro(rs.getString("intro"));
            profile.setStudID(rs.getString("studID"));
        }
        
        rs.close();
        stmt.close();
        conn.close();
        return profile;
    }
    
    private boolean deleteProfileById(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            String sql = "DELETE FROM profiles WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    //prevent duplication of studID
    private boolean studentIdExists(String studID) {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            String sql = "SELECT COUNT(*) FROM profiles WHERE studID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, studID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                rs.close();
                stmt.close();
                conn.close();
                return true;
            }
            
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private boolean validateInput(String name, String email, String studID) {
        if (name == null || name.trim().isEmpty()) return false;
        if (email == null || !email.contains("@")) return false;
        if (studID == null || studID.trim().isEmpty()) return false;
        return true;
    }
    
    
}