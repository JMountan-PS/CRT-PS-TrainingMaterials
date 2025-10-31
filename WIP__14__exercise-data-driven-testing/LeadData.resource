
Copy code
*** Settings ***
Documentation    Lead test data for Salesforce lead creation tests
...              Contains sample lead records as dictionaries for data-driven testing


*** Variables ***
# Lead Test Data - List of Dictionaries
# Each lead is a dictionary that can be accessed in a FOR loop

@{LEADS_DATA}
...    &{LEAD_1}
...    &{LEAD_2}
...    &{LEAD_3}
...    &{LEAD_4}

# Lead 1 - Sarah Johnson (Open - Website)
&{LEAD_1}
...    lead_status=Open
...    last_name=Johnson
...    company=Acme Corporation
...    first_name=Sarah
...    salutation=Ms.
...    phone=555-0101
...    title=VP of Sales
...    email=sarah.johnson@acme.com
...    website=www.acme.com
...    lead_source=Website

# Lead 2 - Michael Chen (Working - External Referral)
&{LEAD_2}
...    lead_status=Working
...    last_name=Chen
...    company=TechStart Inc
...    first_name=Michael
...    salutation=Mr.
...    phone=555-0102
...    title=Chief Technology Officer
...    email=michael.chen@techstart.com
...    website=www.techstart.com
...    lead_source=External Referral

# Lead 3 - Emily Rodriguez (Qualified - Trade Show)
&{LEAD_3}
...    lead_status=Qualified
...    last_name=Rodriguez
...    company=Global Dynamics
...    first_name=Emily
...    salutation=Ms.
...    phone=555-0103
...    title=Operations Director
...    email=emily.r@globaldynamics.com
...    website=www.globaldynamics.com
...    lead_source=Trade Show

# Lead 4 - David Kim (New - Partner)
&{LEAD_4}
...    lead_status=New
...    last_name=Kim
...    company=Innovate Labs
...    first_name=David
...    salutation=Dr.
...    phone=555-0104
...    title=Research Director
...    email=david.kim@innovatelabs.com
...    website=www.innovatelabs.com
...    lead_source=Partner