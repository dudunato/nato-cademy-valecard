/**
 * Created by dudunato on 16/02/23.
 */

import {LightningElement, track} from 'lwc';

import getContacts from '@salesforce/apex/TestServerController.getContacts'
import savePayment from '@salesforce/apex/PaymentController.savePayment'
import getPayments from '@salesforce/apex/PaymentController.getPayments'
import deletePayment from '@salesforce/apex/PaymentController.deletePayment'
import getOpportunities from '@salesforce/apex/PaymentController.getOpportunitiesBySearchTerm'
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class PaymentManagement extends LightningElement {

    contactOptions;
    currentOpportunityId;

    @track
    opportunityOptions;

    @track
    payments;

    @track
    loading;

    @track
    payment;

    @track
    showForm;

    @track
    showOpportunityForm;

    constructor() {
        super();
        this.contactOptions = [];
        this.opportunityOptions = [];
        this.payments = [];
        this.payment = {};
        this.loading = true;
        this.showForm = false;
        this.showOpportunityForm = false;
    }

    get hasOpportunities() {
        return this.opportunityOptions.length > 0;
    }

    async connectedCallback() {
        await this.loadContacts();
        await this.loadPayments();
        this.loading = false;
    }

    async loadContacts() {
        const contacts = await getContacts();
        this.contactOptions = contacts.map((c) => {
           return  {label: c.Name, value: c.Id};
        });
    }

    async loadPayments() {
        const payments = await getPayments();

        payments.forEach((p) => {
            if (!p.Opportunity__r) p.Opportunity__r = {Name : '', Bonus__c: 0};
        });

        this.payments = payments;
    }

    async loadOpportunities(searchTerm) {
        const opportunities = await getOpportunities({
            searchTerm: searchTerm
        });
        this.opportunityOptions = opportunities.map((o) => {
            return  {label: o.Name, value: o.Id};
        });
    }

    handlePaymentFormChange(event) {
        this.payment[event.target.name] = event.target.value;
    }

    togglePaymentForm() {
        this.showForm = !this.showForm;
    }

    async handleSave() {
        this.loading = true;

        await savePayment({payment: this.payment});

        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Payment saved successfully!',
            variant: 'success'
        }));

        await this.loadPayments();
        this.payment = {};
        this.togglePaymentForm();
        this.loading = false;
    }

    sendToEdit(event) {
        this.payment = {...event.target.value};
        this.togglePaymentForm();
    }

    async handleDelete(event) {
        this.loading = true;

        await deletePayment({paymentId: event.target.value});

        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Payment deleted successfully!',
            variant: 'success'
        }));

        await this.loadPayments();
        this.loading = false;
    }

    toggleOpportunityForm() {
        this.showOpportunityForm = !this.showOpportunityForm;
    }

    handleOpportunityForm(event) {
        this.payment = {...event.target.value};
        this.toggleOpportunityForm();
    }

    async handleSearchOpportunity(event) {
        this.loading = true;
        const value = [...this.template.querySelectorAll('lightning-input')].filter((el) => el.name === 'searchTerm')[0].value;
        await this.loadOpportunities(value);
        this.loading = false;
    }

    handleOpportunitySelect(event) {
        this.currentOpportunityId = event.target.value;
    }

    async handleOpportunitySet(event) {
        this.loading = true;

        await savePayment({payment: {Id: this.payment.Id, Opportunity__c: this.currentOpportunityId}});

        this.dispatchEvent(new ShowToastEvent({
            title: '',
            message: 'Opportunity set successfully!',
            variant: 'success'
        }));

        await this.loadPayments();
        this.payment = {};
        this.toggleOpportunityForm();
        this.loading = false;
    }


}