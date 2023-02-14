/**
*@description: To retrieve a random Chuck Norris joke from the API @ https://api.chucknorris.io/ WITHOUT named credentials
*@author: Sachin Kumar
*@createddate: 2023/02/08
*/
public inherited sharing class NorrisConnector {
    /**
    *@description To retrieve a random Chuck Norris joke from the given endpoint, WITHOUT named credentials
    *@return HttpResponse - returning the response in JSON format received from API end point
    */
    public static HttpResponse retriveRandomChunk(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.chucknorris.io/jokes/random');// Storing this URL in Custom Metadata Type abd then fetching it in Code is the best practice
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
        // Deserialize the JSON string into collections of primitive data types.
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        // Cast the values from the received random chuck
        Object randomchunk = (Object)results.get('value');
        }
        return response;
    }
    /**
    *@description Asynchronously takes a Case Id as an argument (in form of List) and write the above received joke into the respective Case description field 
    *@param caseIdSet - Set of CaseIds
    *@return void
    */
    @future(callout=true)
    public static void updateCaseWithRetrivedRandomChunk(Set<Id> caseIdSet){
        HttpResponse response = retriveRandomChunk();
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values from the received random chuck
            Object randomchunk = (Object)results.get('value');            
            List<Case> caseList = [SELECT Id, Description FROM Case WHERE Id In :caseIdSet];
            List<Case> caseListToUpdate = new List<Case>();           
            for(Case caseRecord : caseList){
                caseRecord.Description = randomchunk.toString();
                caseListToUpdate.add(caseRecord);
            }
            update caseListToUpdate;
        }
    }
}