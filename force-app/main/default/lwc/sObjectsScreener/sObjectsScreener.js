/**
 * Created by dudunato on 21/03/23.
 */

import {LightningElement, track} from 'lwc';

import getObjects from '@salesforce/apex/TestServerController.getObjects'
import getFields from '@salesforce/apex/TestServerController.getFields'

export default class SObjectsScreener extends LightningElement {

    @track
    loading;

    @track
    sObjectOptions;

    @track
    currentFields;

    allFields;

    constructor() {
        super();
        this.loading = true;
        this.sObjectOptions = [];
        this.currentFields = [];
        this.allFields = [];
    }

    async connectedCallback() {
        await this.loadSObjectNames();
    }

    get sObjectListLabel() {
        return `SObject List (${this.sObjectOptions.length})`;
    }

    async loadSObjectNames() {

        const sObjects = await getObjects();
        sObjects.sort((a, b) => a.label.localeCompare(b.label));

        this.sObjectOptions = sObjects.map(sObject => {
            return {
                label: sObject.label,
                value: sObject.value
            }
        });

        this.loading = false;
    }

    async handleSObjectChange(event) {
        this.loading = true;
        await this.getFields(event.target.value)
        this.loading = false;
    }

    async getFields(objectName) {
         this.currentFields = await getFields({objectName: objectName});
         this.allFields = this.currentFields;
    }

    filterFields(event) {
        const filter = event.target.value.toLowerCase();

        if (!filter) {
            this.currentFields = this.allFields;
            return;
        }

        this.currentFields = this.allFields.filter(field => {
            return field.label.toLowerCase().includes(filter) || field.apiName.toLowerCase().includes(filter);
        });
    }

}