/**
 * Created by dudunato on 02/03/23.
 */

public with sharing class BasicHttp {

    private final Http http;
    private String endpoint;

    public BasicHttp(String endpoint) {
        this.http = new Http();
        this.endpoint = endpoint;
    }

    public Object doGet() {
        return this.doGet(null);
    }

    public Object doGet(String queryParam) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
                this.endpoint
                + (queryParam != null ? queryParam : '')
        );
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        HttpResponse response = this.http.send(req);

        return JSON.deserializeUntyped(response.getBody());
    }

}