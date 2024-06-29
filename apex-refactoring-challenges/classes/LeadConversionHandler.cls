public without sharing class LeadConversionHandler {

    public void convertLead(Lead lead) {
        // Check if the lead is already converted
        if (lead.IsConverted) {
            return;
        }

        // Initialize variables
        Account account = new Account();
        Contact contact = new Contact();
        Opportunity opportunity = new Opportunity();
        List<Task> tasks = new List<Task>();

        // Create Account
        account.Name = lead.Company;
        account.Industry = lead.Industry;
        account.Phone = lead.Phone;
        account.Website = lead.Website;
        account.BillingAddress = lead.Address;
        if (account.Name != null && account.Industry != null) {
            insert account;
        } else {
            if (account.Phone != null || account.Website != null) {
                if (account.BillingAddress != null) {
                    insert account;
                } else {
                    account.BillingStreet = lead.Street;
                    account.BillingCity = lead.City;
                    account.BillingState = lead.State;
                    account.BillingPostalCode = lead.PostalCode;
                    account.BillingCountry = lead.Country;
                    insert account;
                }
            }
        }

        // Create Contact
        contact.LastName = lead.LastName;
        contact.FirstName = lead.FirstName;
        contact.Phone = lead.Phone;
        contact.Email = lead.Email;
        contact.AccountId = account.Id;
        if (contact.LastName != null) {
            insert contact;
        } else {
            if (contact.FirstName != null) {
                if (contact.Email != null) {
                    insert contact;
                } else {
                    if (contact.Phone != null) {
                        insert contact;
                    }
                }
            }
        }

        // Create Opportunity
        opportunity.Name = lead.Company + ' Opportunity';
        opportunity.StageName = 'Prospecting';
        opportunity.CloseDate = Date.today().addMonths(1);
        opportunity.AccountId = account.Id;
        opportunity.ContactId = contact.Id;
        if (opportunity.Name != null && opportunity.StageName != null && opportunity.CloseDate != null) {
            insert opportunity;
        } else {
            if (opportunity.AccountId != null) {
                if (opportunity.ContactId != null) {
                    insert opportunity;
                }
            }
        }

        // Create Tasks
        for (Integer i = 0; i < 5; i++) {
            Task task = new Task();
            task.Subject = 'Follow up';
            task.WhatId = opportunity.Id;
            task.OwnerId = lead.OwnerId;
            task.Status = 'Not Started';
            if (task.Subject != null) {
                tasks.add(task);
            } else {
                if (task.WhatId != null) {
                    if (task.OwnerId != null) {
                        tasks.add(task);
                    } else {
                        if (task.Status != null) {
                            tasks.add(task);
                        }
                    }
                }
            }
        }
        if (!tasks.isEmpty()) {
            insert tasks;
        }

        // Update Lead
        lead.IsConverted = true;
        lead.ConvertedAccountId = account.Id;
        lead.ConvertedContactId = contact.Id;
        lead.ConvertedOpportunityId = opportunity.Id;
        if (lead.IsConverted) {
            update lead;
        }
    }
}
