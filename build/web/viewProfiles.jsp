<%-- 
    Document   : viewProfiles
    Created on : Jan 3, 2026, 5:04:57 PM
    Author     : amira
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.profileapp.ProfileBean" %>
<%@ page import="java.util.ArrayList" %>
<%
    ArrayList<ProfileBean> profilesList = (ArrayList<ProfileBean>) request.getAttribute("profilesList");
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>All Profiles</title>
        <style>
            body {
                background-color: aliceblue;
                font-family: "Monaco", monospace;
                margin: 0;
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                background-color: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }

            h2 {
                text-align: center;
                color: #333;
            }

            .search-form {
                text-align: center;
                margin: 20px 0;
            }

            .search-form input[type="text"] {
                padding: 8px;
                width: 300px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            .search-form input[type="submit"] {
                padding: 8px 20px;
                background-color: #dfecff;
                border: 1px solid #ccc;
                border-radius: 4px;
                cursor: pointer;
            }

            .search-form input[type="submit"]:hover {
                background-color: #bacbe4;
            }

            .profiles-table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
            }

            .profiles-table th, .profiles-table td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            .profiles-table th {
                background-color: #dfecff;
                color: #333;
            }

            .action-links a {
                color: #1e3a8a;
                text-decoration: none;
                margin-right: 10px;
                padding: 4px 8px;
                border: 1px solid #1e3a8a;
                border-radius: 4px;
                font-size: 14px;
            }

            .action-links a:hover {
                background-color: #1e3a8a;
                color: white;
            }

            .btn-container {
                text-align: center;
                margin-top: 20px;
            }

            .btn {
                background-color: #dfecff;
                border: 1px solid #ccc;
                border-radius: 20px;
                padding: 10px 20px;
                text-decoration: none;
                color: #333;
                font-size: 16px;
                display: inline-block;
            }

            .btn:hover {
                background-color: #bacbe4;
                color: white;
            }

            .message {
                padding: 10px;
                margin: 10px 0;
                border-radius: 4px;
                text-align: center;
            }

            .error {
                background-color: #ffebee;
                color: #c62828;
                border: 1px solid #ffcdd2;
            }

            .success {
                background-color: #e8f5e8;
                color: #2e7d32;
                border: 1px solid #c8e6c9;
            }

            .empty-message {
                text-align: center;
                padding: 40px;
                color: #666;
                font-size: 18px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>All Student Profiles</h2>

            <% if (error != null) { %>
                <div class="message error">
                    <strong>Error:</strong> <%= error %>
                </div>
            <% } %>

            <% if (message != null) { %>
                <div class="message success">
                    <%= message %>
                </div>
            <% } %>
            <div style="text-align: center; color: #666; font-size: 14px;">
                Total Profiles: <%= profilesList != null ? profilesList.size() : 0 %>
            </div>
            <div class="search-form">
                <form action="ProfileServlet" method="get">
                    <input type="text" name="searchName" placeholder="🔍 Search by Name" value="<%= request.getParameter("searchName") != null ? request.getParameter("searchName") : "" %>">
                    <input type="submit" value="Search">
                    <% if (request.getParameter("searchName") != null && !request.getParameter("searchName").trim().isEmpty()) { %>
                        <a href="ProfileServlet" style="margin-left: 10px;">Clear Search</a>
                    <% } %>
                </form>
            </div>

            <% if (profilesList != null && !profilesList.isEmpty()) { %>
                <table class="profiles-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Student ID</th>
                            <th>Email</th>
                            <th>Program</th>
                            <th>Hobbies</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(ProfileBean p : profilesList) { %>
                        <tr>
                            <td><%= p.getName() %></td>
                            <td><%= p.getStudID() %></td>
                            <td><%= p.getEmail() %></td>
                            <td><%= p.getProgram() %></td>
                            <td>
                                <% 
                                    if (p.getHobbies() != null && !p.getHobbies().trim().isEmpty()) {
                                        String[] hobbies = p.getHobbies().split(",");
                                        if (hobbies.length > 3) {
                                            out.print(hobbies[0].trim() + ", " + hobbies[1].trim() + ", " + hobbies[2].trim() + "...");
                                        } else {
                                            out.print(p.getHobbies());
                                        }
                                    } else {
                                        out.print("-");
                                    }
                                %>
                            </td>
                            <td class="action-links">
                                <a href="ProfileServlet?action=view&id=<%= p.getId() %>">View</a>
                                <a href="ProfileServlet?action=edit&id=<%= p.getId() %>">Edit</a>
                                <a href="ProfileServlet?action=delete&id=<%= p.getId() %>" onclick="return confirm('Are you sure you want to delete <%= p.getName() %>\'s profile?')">Delete</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-message">
                    📭 No profiles found.
                    <% if (request.getParameter("searchName") != null && !request.getParameter("searchName").trim().isEmpty()) { %>
                        <br>Try a different search term.
                    <% } %>
                </div>
            <% } %>

            <div class="btn-container">
                <a href="detailsPage.jsp" class="btn">➕ Add New Profile</a>
            </div>
        </div>

        <script>
            //delete confirmation
            function confirmDelete(name) {
                return confirm("Are you sure you want to delete " + name + "'s profile?");
            }
        </script>
    </body>
</html>