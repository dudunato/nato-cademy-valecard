/**
 * Created by dudunato on 21/03/23.
 */

@IsTest
global class MockHttpResponseGenerator implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {
        System.debug('request.endpoint: ' + request.getEndpoint());
//        Assert.areEqual('https://api.github.com/users/dudunato', request.getEndpoint());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(
                new Map<String, Object> {
                       'code' => '38412-180',
                       'state' => 'MG',
                       'city' => 'Uberlândia',
                       'district' => 'Cidade Jardim',
                       'address' => 'Rua das Ipoméias',
                       'status' => 200,
                       'ok' => true,
                       'statusText' => 'ok'
                }
        ));

        res.setStatusCode(200);
        return res;
    }
}