({
    go: function(component, event, helper) {
        console.log('controler go...');
        helper.load(component);
    },
    searchData: function (component, event, helper) {
        console.log('controler searchData...');
        component.set('v.isLoading', true);

        const searchTerm = event.getSource().get('v.value');
        console.log('searchTerm:', searchTerm);
        component.set('v.searchTerm', searchTerm);

        if (helper.typingTimeout) clearTimeout(helper.typingTimeout);

        helper.typingTimeout = setTimeout(() => {
            helper.filterData(component, searchTerm);
        }, 500);

        setTimeout(() => {
            component.set('v.isLoading', false);
        }, 500);
    }
})