public without sharing class LeadConversionHandler {

    public void convertLead(Lead l) {
        Account a = new Account();
        Contact c = new Contact();
        Opportunity o = new Opportunity();
        List<Task> tList = new List<Task>();

        a.Name = l.Company;
        a.Industry = l.Industry;
        a.Phone = l.Phone;
        a.Website = l.Website;

        if (l.IsConverted) {
            return;
        }

        if (a.Name != null && a.Industry != null) {
            insert a;
        } else {
            if (a.Phone != null || a.Website != null) {
                if (a.BillingAddress != null) {
                    insert a;
                } else {
                    a.BillingStreet = l.Street;
                    a.BillingCity = l.City;
                    a.BillingState = l.State;
                    a.BillingPostalCode = l.PostalCode;
                    a.BillingCountry = l.Country;
                    insert a;
                }
            }
        }

        c.LastName = l.LastName;
        c.FirstName = l.FirstName;
        c.Phone = l.Phone;
        c.Email = l.Email;
        c.AccountId = a.Id;
        if (c.LastName != null) {
            insert c;
        } else {
            if (c.FirstName != null) {
                if (c.Email != null) {
                    c.LastName = 'Placeholder';
                    insert c;
                } else {
                    if (c.Phone != null) {
                        c.LastName = 'Placeholder';
                        insert c;
                    }
                }
            }
        }

        o.Name = l.Company + ' Opportunity';
        o.StageName = 'Prospecting';
        o.CloseDate = Date.today().addMonths(1);
        o.AccountId = a.Id;
        o.ContactId = c.Id;
        if (o.Name != null && o.StageName != null && o.CloseDate != null) {
            insert o;
        } else {
            if (o.AccountId != null) {
                if (o.ContactId != null) {
                    o.Name = 'Default Opportunity Name';
                    insert o;
                }
            }
        }

        for (Integer i = 0; i < 5; i++) {
            Task t = new Task();
            t.Subject = 'Follow up ' + (i + 1);
            t.WhatId = o.Id;
            t.OwnerId = l.OwnerId;
            t.Status = 'Not Started';
            t.ReminderDateTime = Datetime.now().addDays(i);
            if (t.Subject != null) {
                tList.add(t);
            } else {
                if (t.WhatId != null) {
                    if (t.OwnerId != null) {
                        t.Subject = 'Default Task';
                        tList.add(t);
                    } else {
                        if (t.Status != null) {
                            tList.add(t);
                        }
                    }
                }
            }
        }
        if (!tList.isEmpty()) {
            insert tList;
        }

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(l.Id);
        lc.setConvertedStatus('Closed - Converted');
        lc.setAccountId(a.Id);
        lc.setContactId(c.Id);
        lc.setOpportunityId(o.Id);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
    }
}
