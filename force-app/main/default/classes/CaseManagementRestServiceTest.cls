@isTest
public with sharing class CaseManagementRestServiceTest {
    
    //Create test data
    @testSetup
    static void setupTestData() {
        Case testCase = new Case(
            Subject = 'Test Case', 
            Description = 'This is a test case for unit testing purposes.',
            Priority = 'Medium',
            Origin = 'Phone',
            Status = 'New'
        );
        insert testCase;
    }

    //generate fake caseId
    private static String getFakeCaseId() {
        String prefix = Case.SObjectType.getDescribe().getKeyPrefix();
        return prefix + '0'.repeat(15) + 'AAA'; // A fake case Id that does not exist in the database
    }

    @isTest
    static void testGetCaseWithValidIdreturnCase() {
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/case-management/' + testCase.Id;
        req.httpMethod = 'GET';
        
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;
       

        Test.startTest();
        System.runAs(currentUser){
             CaseManagementRestService.ApiResponse response = CaseManagementRestService.getCase();
             Assert.isTrue(response.success, 'Expected success to be true');
             Assert.areEqual('Case found', response.message, 'Expected message to indicate case was found');
        }
       
        Test.stopTest();    
    }

    @isTest
    static void testCreateCaseWithValidRequestCreatedCase() {
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/case-management';
        req.httpMethod = 'POST';
        
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        CaseManagementRestService.CaseRequest caseRequest = new CaseManagementRestService.CaseRequest();
        caseRequest.subject = 'New Test Case';
        caseRequest.status = 'New';
        caseRequest.description = 'This is a new test case for unit testing purposes.';
        caseRequest.Origin = 'Email';
        caseRequest.Priority = 'High';   

        Test.startTest();
        System.runAs(currentUser){
            CaseManagementRestService.ApiResponse response = CaseManagementRestService.createCase(caseRequest);
            Assert.isTrue(response.success, 'Expected success to be true');
            Assert.areEqual('Case created successfully', response.message, 'Expected message to indicate case was created successfully');
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateCaseWithValidRequestUpdatesCase() {
        Case testCase = [SELECT Id, Subject, Status, Priority, Description, Origin FROM Case LIMIT 1];
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/case-management/' + testCase.Id;
        req.httpMethod = 'PUT';
        
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        CaseManagementRestService.CaseRequest caseRequest = new CaseManagementRestService.CaseRequest();
        caseRequest.subject = 'Updated Test Case';
        caseRequest.status = 'Working';
        caseRequest.description = 'This is an updated test case for unit testing purposes.';
        caseRequest.Origin = 'Web';
        caseRequest.Priority = 'Low';   

        Test.startTest();
        System.runAs(currentUser){
            CaseManagementRestService.ApiResponse response = CaseManagementRestService.updateCase(caseRequest);
            Assert.isTrue(response.success, 'Expected success to be true');
            Assert.areEqual('Case updated successfully', response.message, 'Expected message to indicate case was updated successfully');
        }
        Test.stopTest();
    }

    @isTest
    static void testPatchCaseWithValidRequestPatchesCase() {
        Case testCase = [SELECT Id, Subject, Status, Priority, Description, Origin FROM Case LIMIT 1];  
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/case-management/' + testCase.Id;
        req.httpMethod = 'PATCH';

        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;     

        CaseManagementRestService.CaseRequest caseRequest = new CaseManagementRestService.CaseRequest();
        caseRequest.subject = 'Patched Test Case';
        caseRequest.status = 'Closed';
        caseRequest.description = 'This is a patched test case for unit testing purposes.';
        caseRequest.Origin = 'Chat';
        caseRequest.Priority = 'Medium';    

        Test.startTest();
        System.runAs(currentUser){
            CaseManagementRestService.ApiResponse response = CaseManagementRestService.patchCase(caseRequest);
            Assert.isTrue(response.success, 'Expected success to be true');
            Assert.areEqual('Case updated successfully', response.message, 'Expected message to indicate case was patched successfully');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteCaseWithValidId() {
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        User currentUser = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/case-management/' + testCase.Id;
        req.httpMethod = 'DELETE';
        
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        System.runAs(currentUser){
            CaseManagementRestService.ApiResponse response = CaseManagementRestService.deleteCase();
            Assert.isTrue(response.success, 'Expected success to be true');
            Assert.areEqual('Case deleted successfully', response.message, 'Expected message to indicate case was deleted successfully');
        }
        Test.stopTest();
    }
}