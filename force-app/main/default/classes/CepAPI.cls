/**
 * Created by dudunato on 02/03/23.
 */

public with sharing class CepAPI {

    private final BasicHttp http;

    public CepAPI() {
        this.http = new BasicHttp('callout:CEPApi');
    }

    // new CepAPI().fetch('01001000')
    public Map<String, Object> fetch(String cepNumber) {
        String pathURL = '/file/apicep/' + cepNumber + '.json';
        return (Map<String, Object>) this.http.doGet(pathURL);
    }

}