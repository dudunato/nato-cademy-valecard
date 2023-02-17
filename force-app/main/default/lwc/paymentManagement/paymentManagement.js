/**
 * Created by dudunato on 16/02/23.
 */

import {LightningElement, track} from 'lwc';

import getContacts from '@salesforce/apex/TestServerController.getContacts'
import savePayment from '@salesforce/apex/PaymentController.savePayment'
import getPayments from '@salesforce/apex/PaymentController.getPayments'
import deletePayment from '@salesforce/apex/PaymentController.deletePayment'
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class PaymentManagement extends LightningElement {

    contactOptions;

    @track
    payments;

    @track
    loading;

    @track
    payment;

    @track
    showForm;

    constructor() {
        super();
        this.contactOptions = [];
        this.payments = [];
        this.payment = {};
        this.loading = true;
        this.showForm = false;
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
        this.payments = await getPayments();
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


}