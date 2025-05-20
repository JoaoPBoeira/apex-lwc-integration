public with sharing class HttpClient {

    public static HttpResponse get(String path) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ReqRes_API_Key' + path);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        return http.send(request);
    }

    public static HttpResponse post(String path, String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ReqRes_API_Key' + path);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        return http.send(request);
    }

    public static HttpResponse put(String path, String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ReqRes_API_Key' + path);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        return http.send(request);
    }

    public static HttpResponse delet(String path) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ReqRes_API_Key' + path);
        request.setMethod('DELETE');
        request.setHeader('Content-Type', 'application/json');
        return http.send(request);
    }
}