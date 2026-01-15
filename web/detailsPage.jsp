<%-- 
    Document   : detailsPage
    Created on : Nov 17, 2025, 11:10:11 PM
    Author     : amira
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add New Profile</title>
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
        </style>
    </head>
    <body>
        <h2 style="text-align: center;">Personal Information Form</h2>
        <form method="post" action="ProfileServlet">
            Name: <input type="text" name="name" required><br><br>
            Student ID: <input type="text" name="studID" required><br><br>
            Email: <input type="email" name="email" required><br><br>
            Program: <input type="text" name="program" required><br><br>
            Hobbies (comma-separated): <input type="text" name="hobbies"><br><br>
            Self Introduction:<br>
            <textarea name="intro" rows="4" required></textarea><br><br>

            <div class="btn">
                <input type="submit" value="Save Profile">
            </div>
        </form>
    </body>
</html>