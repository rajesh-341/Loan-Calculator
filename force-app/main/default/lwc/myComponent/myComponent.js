import { LightningElement } from 'lwc';

export default class MyComponent extends LightningElement {

    name = '';
    email = '';
    phone = '';
    subject = '';
    description = '';
    severity = '';
    showSuccess = false;

    severityOptions = [
        { label: 'High', value: 'High' },
        { label: 'Medium', value: 'Medium' },
        { label: 'Low', value: 'Low' }
    ];

    handleChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleSubmit() {
        const formData = new FormData();
        formData.append('orgid', '00D5h000008th3a');
        formData.append('retURL', 'https://omnicloud-dev-ed.develop.lightning.force.com/lightning/o/Case/list');

        formData.append('name', this.name);
        formData.append('email', this.email);
        formData.append('phone', this.phone);
        formData.append('subject', this.subject);
        formData.append('description', this.description);
        formData.append('00NJ2000002i0C8', this.severity);

        fetch('https://webto.salesforce.com/servlet/servlet.WebToCase?encoding=UTF-8&orgId=00D5h000008th3a', {
            method: 'POST',
            body: formData,
            mode: 'no-cors'
        })
        .then(() => {
            this.showSuccess = true;
            // Optionally reset the form
            window.location.href = 'https://omnicloud-dev-ed.develop.lightning.force.com/lightning/o/Case/list';
        })
        .catch(error => {
            console.error('Form submission failed:', error);
        });
    }
}