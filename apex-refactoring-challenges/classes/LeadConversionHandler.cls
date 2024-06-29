public without sharing class LeadConversionHandler {

    private static final LeadStatus convertStatus = [SELECT Id, apiname FROM LeadStatus WHERE Isconverted=true LIMIT 1];

    public void convertLead(Lead l) {
        Account a = new Account();
        Contact c = new Contact();
        Opportunity o = new Opportunity();
        List<Task> tList = new List<Task>();
        Integer tNum = 5;

        a.Name = l.Company;
        a.Industry = l.Industry;
        a.Phone = l.Phone;
        a.Website = l.Website;

        if (l.IsConverted) {
            return;
        }

        if (a.Name != null /*&& a.Industry != null*/) {
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

// "ThePreviousConsultant" - 24-10-27 - commented out, as per SPN-1234
//        c.LastName = l.LastName;
//        c.FirstName = l.FirstName;
//        c.Phone = l.Phone;
//        c.Email = l.Email;
//        c.AccountId = a.Id;
//        if (c.LastName != null) {
//            insert c;
//        } else {
//            if (c.FirstName != null) {
//                if (c.Email != null) {
//                    c.LastName = 'Placeholder';
//                    insert c;
//                } else {
//                    if (c.Phone != null) {
//                        c.LastName = 'Placeholder';
//                        insert c;
//                    }
//                }
//            }
//        }

        o.Name = l.Company + ' Opportunity';
        o.StageName = 'Prospecting';
        o.CloseDate = Date.today().addMonths(1);
        o.AccountId = a.Id;
        o.ContactId = c.Id;
        if (o.Name != null) {
            if (o.StageName != null && o.CloseDate != null)
                System.debug('*** Lead conversion for opportunity ***');
                insert o;
        } else {
            if (o.AccountId != null) {
                if (o.ContactId != null) {
                    o.Name = 'Default Opportunity Name';
                    insert o;
                }
            }
        }

        for (Integer i = 0; i < tNum; i++) {
            Task t = new Task();
            t.Subject = 'Follow up ' + (i + 1);
            t.WhatId = o.Id;
            t.OwnerId = UserInfo.getUserId();
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
        lc.setConvertedStatus(convertStatus.ApiName);
        lc.setAccountId(a.Id);
//        lc.setContactId(c.Id);
        lc.setOpportunityId(o.Id);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
    }
}
