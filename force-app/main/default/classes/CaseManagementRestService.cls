@RestResource(urlMapping='/case-management/*')
global with sharing class CaseManagementRestService {
   
    @httpget
    global static ApiResponse getCase(){

        String caseId = extractCaseIdFromUrl();

        if(String.isBlank(caseId)){
            RestContext.response.statusCode = 400;
            return errorResponse('Case Id is required');
        }

        List<Case> caseList = [SELECT Id, CaseNumber, Subject, Status, Priority FROM Case WHERE Id = :caseId LIMIT 1];
        //Case Not found, return 404
        if(caseList.isEmpty()){
            RestContext.response.statusCode = 404;
            return errorResponse('Case not found');
        }
        
        //Case found, return 200 with case data
        Case c = caseList[0];
        CaseData caseData = new CaseData();
        caseData.caseId = c.Id;
        caseData.caseNumber = c.CaseNumber;
        caseData.subject = c.Subject;
        caseData.status = c.Status;
        caseData.priority = c.Priority;
        RestContext.response.statusCode = 200;
        return successResponse('Case found', caseData);
    }

    @httppost
    global static ApiResponse createCase(CaseRequest request) {
        Case newCase = new Case();
        newCase.Subject = request.subject;
        newCase.Status = request.status;
        newCase.Priority = request.priority;
        newCase.Description = request.description;
        newCase.Origin = request.origin;
        
        try {
            insert newCase;

            //query the inserted case
            Case caseCreated = [SELECT Id, CaseNumber, Subject, Status, Priority, Description, Origin FROM Case WHERE Id = :newCase.Id LIMIT 1];

            CaseData responseData = new CaseData();
            responseData.caseNumber = newCase.CaseNumber;
            responseData.subject = newCase.Subject;
            responseData.status = newCase.Status;
            responseData.priority = newCase.Priority;
            responseData.description = newCase.Description;
            responseData.origin = newCase.Origin;
            return successResponse('Case created successfully', responseData);
        } catch (Exception e) {
            RestContext.response.statusCode = 500; // Internal Server Error
            return errorResponse('Error creating case: ' + e.getMessage());
        }
    }

    @httpput
    global static ApiResponse updateCase(CaseRequest request) {
        String caseId = extractCaseIdFromUrl();
        List<Case> caseList = [SELECT Id, CaseNumber, Subject, Status, Priority, Description, Origin FROM Case WHERE Id = :caseId LIMIT 1];

        if(!caseList.isEmpty()){
            Case caseToUpdate = caseList[0];
            caseToUpdate.Subject = request.subject;
            caseToUpdate.Status = request.status;
            caseToUpdate.Priority = request.priority;
            caseToUpdate.Description = request.description;
            caseToUpdate.Origin = request.origin;

            try {
                update caseToUpdate;

                CaseData responseData = new CaseData();
                responseData.caseId = caseToUpdate.Id;
                responseData.caseNumber = caseToUpdate.CaseNumber;
                responseData.subject = caseToUpdate.Subject;
                responseData.status = caseToUpdate.Status;
                responseData.priority = caseToUpdate.Priority;
                responseData.description = caseToUpdate.Description;
                responseData.origin = caseToUpdate.Origin;

                return successResponse('Case updated successfully', responseData);
            } catch (Exception e) {
                RestContext.response.statusCode = 500; // Internal Server Error
                return errorResponse('Error updating case: ' + e.getMessage());
            }
        } else {
            RestContext.response.statusCode = 404; // Not Found
            return errorResponse('Case not found');
        }
    }

    @httppatch
    global static ApiResponse patchCase(CaseRequest request) {
        String caseId = extractCaseIdFromUrl();
        List<Case> caseList = [SELECT Id, CaseNumber, Subject, Status, Priority, Description, Origin FROM Case WHERE Id = :caseId LIMIT 1]; 

        if(!caseList.isEmpty()){
            Case caseToPatch = caseList[0];
            if(request.subject != null) caseToPatch.Subject = request.subject;
            if(request.status != null) caseToPatch.Status = request.status;
            if(request.priority != null) caseToPatch.Priority = request.priority;
            if(request.description != null) caseToPatch.Description = request.description;
            if(request.origin != null) caseToPatch.Origin = request.origin;

            try {
                update caseToPatch;

                CaseData responseData = new CaseData();
                responseData.caseId = caseToPatch.Id;
                responseData.caseNumber = caseToPatch.CaseNumber;
                responseData.subject = caseToPatch.Subject;
                responseData.status = caseToPatch.Status;
                responseData.priority = caseToPatch.Priority;
                responseData.description = caseToPatch.Description;
                responseData.origin = caseToPatch.Origin;

                return successResponse('Case updated successfully', responseData);
            } catch (Exception e) {
                RestContext.response.statusCode = 500; // Internal Server Error
                return errorResponse('Error updating case: ' + e.getMessage());
            }
        } else {
            RestContext.response.statusCode = 404; // Not Found
            return errorResponse('Case not found');
        }
    }

    @httpdelete
    global static ApiResponse deleteCase() {
        String caseId = extractCaseIdFromUrl();

        if(String.isBlank(caseId)){
            RestContext.response.statusCode = 400;
            return errorResponse('Case Id is required');
        }

        List<Case> caseList = [SELECT Id FROM Case WHERE Id = :caseId LIMIT 1];
        if(!caseList.isEmpty()){
            try {
                delete caseList[0];
                RestContext.response.statusCode = 200;
                return successResponse('Case deleted successfully', null);
            } catch (Exception e) {
                RestContext.response.statusCode = 500; // Internal Server Error
                return errorResponse('Error deleting case: ' + e.getMessage());
            }
        } else {
            RestContext.response.statusCode = 404; // Not Found
            return errorResponse('Case not found');
        }
    }
        
        

    //extract the value from URL parameter
    private static string extractCaseIdFromUrl() {
        RestRequest req = RestContext.request;
        String url = req.requestURI;
        String idFormUrl = url.substringAfterLast('/');
        if(idFormUrl == 'case-management'){
            return null; //No Id provided in the URL
        }
        return idFormUrl;
    }

    private static ApiResponse successResponse(String message, CaseData data) {
        return new ApiResponse(true, message, data);
    }

    private static ApiResponse errorResponse(String message) {
        return new ApiResponse(false, message, null);
    }

    global class ApiResponse {
        public Boolean success;
        public String message;
        public CaseData data;

        public ApiResponse(Boolean success, String message, CaseData data) {
            this.success = success;
            this.message = message;
            this.data = data;
        }

    }

    global class CaseData {
        public String caseId;
        public String caseNumber;
        public String subject;
        public String status;
        public String priority;
        public String description;
        public String origin;

        public CaseData(){}

        public CaseData(String caseId) {
            this.caseId = caseId;
        }
    }

    global class CaseRequest {
        public String subject;
        public String status;
        public String priority;
        public String description;
        public String origin;
    }
}