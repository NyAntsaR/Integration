@RestResource(urlMapping='/welcome/*')
global with sharing class WelcomRestService {

    @HttpGet
    global  static String getWelcomMessage() {
        return 'Welcome to Apex REST Service! Your connection is successful';
    }
}