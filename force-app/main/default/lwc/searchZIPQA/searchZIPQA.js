/**
 * Created by dudunato on 02/03/23.
 */

import {LightningElement} from 'lwc';
import {CloseActionScreenEvent} from 'lightning/actions';

export default class SearchZIPQA extends LightningElement {


    constructor() {
        super();
    }

    connectedCallback() {
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }


}