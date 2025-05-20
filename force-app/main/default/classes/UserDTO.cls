public with sharing class UserDTO {
    
    @AuraEnabled public String id { get; set; }
    @AuraEnabled public String name { get; set; }
    @AuraEnabled public String email { get; set; }
}