/**
 * Created by dudunato on 02/03/23.
 */

import {api, LightningElement, track} from 'lwc';
import {CloseActionScreenEvent} from 'lightning/actions';
import getCEP from '@salesforce/apex/TestServerController.getCEP';
import saveContact from '@salesforce/apex/TestServerController.saveContact';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin} from "lightning/navigation";
// import { RefreshEvent } from 'lightning/refresh';

export default class SearchZIPQA extends LightningElement {

    @api
    recordId;

    @track
    loading;

    constructor() {
        super();
        this.loading = false;
    }

    connectedCallback() {
    }

    async handleSearch(event) {
        this.loading = true;

        const cepNumber = this.template.querySelector('lightning-input').value;
        const cepData = await getCEP({cepNumber: cepNumber});

        if (cepData.code === 'not_found') {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: '',
                    message: 'CEP not found',
                    variant: 'error',
                }),
            );
            this.loading = false;
            return;
        }

        const currentContact = {
            Id: this.recordId,
            MailingStreet: `${cepData.address}, ${cepData.district}`,
            MailingCity: cepData.city,
            MailingState:  cepData.state,
            MailingCountry: 'Brazil',
            MailingPostalCode: cepData.code,
        };

        try {
            await saveContact({contact: currentContact});

            this.dispatchEvent(
                new ShowToastEvent({
                    title: '',
                    message: 'CEP Salvo!',
                    variant: 'success',
                }),
            );

            window.location.href = '/' + this.recordId;

            // this.dispatchEvent(new RefreshEvent());

            this.handleCancel();
        } catch (e) {

            this.dispatchEvent(
                new ShowToastEvent({
                    title: '',
                    message: e.body.message,
                    variant: 'error',
                }),
            );
        }

        this.loading = false;
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }


}