public with sharing class HttpClient {

    public static HttpResponse makeRequest(String path, String body, String method) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<String> httpMethods = new List<String>{'GET', 'POST', 'PUT', 'DELETE'};

        request.setEndpoint('callout:ReqRes_API_Key' + path);
        request.setMethod(method);
        request.setHeader('Content-Type', 'application/json');

        if (method == 'POST' || method == 'PUT') {
            request.setBody(body);
        }

        if (!httpMethods.contains(method)) {
            HttpResponse errorResponse = new HttpResponse();
            errorResponse.setStatusCode(400);
            errorResponse.setStatus('Bad Request');
            errorResponse.setBody('Unsupported HTTP method: ' + method);
            return errorResponse;
        }

        return http.send(request);
    }
}
