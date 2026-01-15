<%-- 
    Document   : editDetails
    Created on : Jan 3, 2026, 8:19:14 PM
    Author     : amira
--%>

<%-- 
    Document   : editForm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.profileapp.ProfileBean"%>
<%
    ProfileBean profile = (ProfileBean) request.getAttribute("profile");
    if (profile == null) {
        response.sendRedirect("ProfileServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Profile</title>
        <style>
            body {
                background-color: aliceblue;
                font-family: "Monaco", monospace;
                margin: 0;
                padding: 0;
            }
            form {
                width: 450px;           
                margin: 40px auto;      
                padding: 20px;
                border: 1px solid #ccc;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                background-color: #dfecff;
            }
            .btn{
                text-align:center;
                margin-top:10px;
            }
            h2 {
                text-align: center;
                color: #4a6fa5;
            }
        </style>
    </head>
    <body>
        <h2>Edit Profile</h2>
        <form method="post" action="ProfileServlet">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= profile.getId() %>">
            
            Name: <input type="text" name="name" value="<%= profile.getName() %>" required><br><br>
            Student ID: <input type="text" name="studID" value="<%= profile.getStudID() %>" required><br><br>
            Email: <input type="email" name="email" value="<%= profile.getEmail() %>" required><br><br>
            Program: <input type="text" name="program" value="<%= profile.getProgram() %>" required><br><br>
            Hobbies (comma-separated): <input type="text" name="hobbies" value="<%= profile.getHobbies() %>"><br><br>
            Self Introduction:<br>
            <textarea name="intro" rows="4" required><%= profile.getIntro() %></textarea><br><br>

            <div class="btn">
                <input type="submit" value="Save Changes">
                <input type="button" value="Cancel" onclick="window.history.back()">
            </div>
        </form>
    </body>
</html>
