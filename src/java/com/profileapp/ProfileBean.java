/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.profileapp;

public class ProfileBean {

    private int id;
    private String name;
    private String email;
    private String program;
    private String hobbies;
    private String intro;
    private String studID;

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
 
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
 
    public String getProgram() {
        return program;
    }
    public void setProgram(String program) {
        this.program = program;
    }
 
    public String getHobbies() {
        return hobbies;
    }
    public void setHobbies(String hobbies) {
        this.hobbies = hobbies;
    }
 
    public String getIntro() {
        return intro;
    }
    public void setIntro(String intro) {
        this.intro = intro;
    }
    
    public String getStudID() {
        return studID;
    }
    public void setStudID(String studID) {
        this.studID = studID;
    }
}

