<%-- 
    Document   : profilePage
    Created on : Nov 17, 2025, 11:14:18 PM
    Author     : amira
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.profileapp.ProfileBean"%>
<%
    ProfileBean profile = (ProfileBean) request.getAttribute("profile");
    if(profile==null){
        response.sendRedirect("detailsPage.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Personal Profile</title>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
        <style>
            body{
                background-color:aliceblue;
                font-family: "Monaco", monospace;
                margin:0;
                padding:0;
            }
            table {           
                width: 70%;
                margin: 20px auto;      
                /*border: 1px solid #ccc;*/
                border-collapse: separate;
                border-radius: 25px;
                border-spacing: 20px;
            }
            table td{
                box-shadow: 0 0 10px rgba(0,0,0,0.2);
                padding: 20px;
                border: 1px solid aliceblue;
                background-color: #dfecff;
                border-radius: 25px;
            }
            .profile-header {
                display: flex;
                align-items: center;
                gap: 16px;
                margin-bottom: 12px;
            }

            .avatar {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                background-color: #bfdbfe;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 26px;
                font-weight: bold;
                color: #1e3a8a;
                flex-shrink: 0;
            }

            .profile-name {
                font-size: 26px; /* 24–28px as requested */
                margin: 0;
            }

            .profile-role {
                font-size: 14px;
                color: #555;
                margin-top: 4px;
            }

            .profile-details p {
                margin: 4px 0;
            }
            
            .btnDiv{
                text-align: center;
            }
            .btn{
                background-color: #dfecff;
                border-radius: 20px;
                font-size: 16px;
                padding: 10px 20px;
                border: none;          
                outline: none; 
            }
            .btn:hover{
                background-color: #bacbe4;
                color: white;
            }
            @media (max-width: 768px) {
                table {
                    width: 90%;
                    border-spacing: 0; /* disable table spacing on mobile */
                }

                table tr {
                    display: block;
                    margin-bottom: 20px; /* ✅ SPACE BETWEEN ROWS */
                }

                table td {
                    display: block;
                    width: 100%;
                    margin-bottom: 20px; /* ✅ SPACE BETWEEN CARDS */
                }

                table td:last-child {
                    margin-bottom: 0;
                }
            }
            .hobby-list{
                padding-left: 20px;
                margin: 0;
            }
            
            .hobby-list li{
                margin-bottom: 6px;
            }
            .hobby-list li::marker {
                color: #1e3a8a;
            }
        </style>
    </head>
    <body>
        
        <h1  style="text-align: center;"><%= profile.getName()%>'s Profile</h1>
        <table>
            <tr>
                <td>
                    <div class="profile-header">
                        <div class="avatar">
                            <%= profile.getName().substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="profile-text">
                            <h2 class="profile-name"><%= profile.getName() %></h2>
                            <p class="profile-role">Student | <%= profile.getProgram() %></p>
                        </div>
                        <br>
                        
                    </div>

                    <div class="profile-details">
                        <p><b>Student Id: </b><%= profile.getStudID() %></p>
                        <p><b>Email: </b><%= profile.getEmail() %></p>
                    </div>
                </td>
                <td>
                    <h3>🧩 Hobbies: </h3>
                    <hr>
                    <ul class="hobby-list">
                        <%
                            String hobbies = profile.getHobbies();
                            if (hobbies != null && !hobbies.trim().isEmpty()) {
                                String[] hobbyArray = hobbies.split(",");
                                for (String hobby : hobbyArray) {
                        %>
                        <li><%= hobby.trim()%></li>
                            <%
                                    }
                                }
                            %>
                    </ul>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <h3>🎤 Self Introduction: </h3>
                    <hr>
                    <p><%= profile.getIntro() %></p>
                </td>
            </tr>
        </table>
        <div class="btnDiv">
            <input type="button" class="btn" value="Edit Profile" onclick="location.href='ProfileServlet?action=edit&id=<%= profile.getId() %>'">
            <input type="button" class="btn" value="View All Profiles" onclick="location.href='ProfileServlet'">
        </div>
    </body>
</html>
