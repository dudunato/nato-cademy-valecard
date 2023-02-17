({
    load: function(component) {
        console.log('helper load...');

        const columns = [
            { label: 'Contact', fieldName: 'Contact__c' },
            { label: 'Invoice', fieldName: 'Invoice__c' },
            { label: 'Opportunity', fieldName: 'Opportunity__c' },
            { label: 'Amount', fieldName: 'PaymentAmount__c' },
            { label: 'Type', fieldName: 'PaymentType__c' },
            { label: 'Reference', fieldName: 'ReferenceNumber__c' },
        ];

        component.set('v.reportData', this.payments);
        component.set('v.columns', columns);
    },
    filterData: function (component, searchTerm) {
        console.log('helper filterData...');
        console.log('searchTerm:', searchTerm);
        if ($A.util.isEmpty(searchTerm)) {
            console.log('all:');
            component.set('v.reportData', this.payments);
            return;
        }

        const filteredResult = this.payments.filter(p => p.PaymentType__c.toUpperCase().includes(searchTerm.toUpperCase()));
        console.log('filteredResult:', filteredResult);

        if(filteredResult) component.set('v.reportData', filteredResult);
    },
    typingTimeout: null,
    payments: [
        {
            Contact__c: 'Id_Contato 0',
            Invoice__c: 'Id_Invoice 0',
            Opportunity__c: 'Id_Opportunity ',
            PaymentAmount__c: 100,
            PaymentType__c: 'Processing',
            ReferenceNumber__c: '123456'
        },
        {
            Contact__c: 'Id_Contato 1',
            Invoice__c: 'Id_Invoice 1',
            Opportunity__c: 'Id_Opportunity ',
            PaymentAmount__c: 100,
            PaymentType__c: 'Processing',
            ReferenceNumber__c: '123456'
        },
        {
            Contact__c: 'Id_Contato 2',
            Invoice__c: 'Id_Invoice 2',
            Opportunity__c: 'Id_Opportunity 2',
            PaymentAmount__c: 100,
            PaymentType__c: 'Approved',
            ReferenceNumber__c: '123456'
        },
        {
            Contact__c: 'Id_Contato 3',
            Invoice__c: 'Id_Invoice 3',
            Opportunity__c: 'Id_Opportunity 3',
            PaymentAmount__c: 100,
            PaymentType__c: 'Rejected',
            ReferenceNumber__c: '123456'
        }
    ]
})