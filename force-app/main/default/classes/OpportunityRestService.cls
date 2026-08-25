@RestResource(urlMapping='/opportunities/*')
global with sharing class OpportunityRestService {
   
    @httpPatch
    global static ResponseWrapper patchOpportunity(PathRequestWrapper requestBody){
        RestRequest req = RestContext.request;
        String opportunityId = req.params.get('id');
        
        //validate if opportunity Id is blank from the request
        if(String.isBlank(opportunityId)){
            RestContext.response.statusCode = 400;
            return new ResponseWrapper(false, 'Opportunity Id is required', null);
        } 

         List<Opportunity> oppList = [SELECT Id, StageName, Amount FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
        
        //Check if the opportinity is found
        if(oppList.isEmpty()){
            RestContext.response.statusCode = 404;
            return new ResponseWrapper(false, 'Opportunity not found', null);
        }

        //Update Opportunity if found
        Opportunity oppToUpdate = oppList[0];

        if(requestBody.StageName != null) oppToUpdate.StageName = requestBody.StageName;
        if(requestBody.Amount != null) oppToUpdate.Amount = requestBody.Amount;
        
        try {
            update oppToUpdate;
            RestContext.response.statusCode = 200;
            return new ResponseWrapper(true, 'Opportunity updated successfully', oppToUpdate.Id);
        } 
        catch(Exception e) {
            RestContext.response.statusCode = 500;
            return new ResponseWrapper(false, 'Error updating Opportunity: ' + e.getMessage(), null);
            
        }
    }

    global class PathRequestWrapper {
        public String StageName;
        public Decimal Amount;
    }

    global class ResponseWrapper {
        public Boolean success;
        public String message;
        public String recordId;

        //constructor
        public ResponseWrapper(Boolean success, String message, String recordId) {
            this.success = success;            
            this.message = message;
            this.recordId = recordId; 
        }
    }
}
