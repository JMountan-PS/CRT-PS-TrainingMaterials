*** Settings ***
Documentation    Comprehensive Lead test data for Salesforce lead creation tests
...              Contains diverse lead records covering all standard fields
...              Organized by test scenario: minimal, standard, complete, edge cases


*** Variables ***
# =============================================================================
# LEAD TEST DATA COLLECTIONS
# =============================================================================

# All Leads - Master List for Data-Driven Testing
@{ALL_LEADS}
...    &{LEAD_MINIMAL}
...    &{LEAD_STANDARD_1}
...    &{LEAD_STANDARD_2}
...    &{LEAD_STANDARD_3}
...    &{LEAD_STANDARD_4}
...    &{LEAD_COMPLETE_1}
...    &{LEAD_COMPLETE_2}
...    &{LEAD_EDGE_CASE_1}
...    &{LEAD_EDGE_CASE_2}

# Minimal Leads - Only Required Fields
@{MINIMAL_LEADS}
...    &{LEAD_MINIMAL}

# Standard Leads - Common Business Scenarios
@{STANDARD_LEADS}
...    &{LEAD_STANDARD_1}
...    &{LEAD_STANDARD_2}
...    &{LEAD_STANDARD_3}
...    &{LEAD_STANDARD_4}

# Complete Leads - All Fields Populated
@{COMPLETE_LEADS}
...    &{LEAD_COMPLETE_1}
...    &{LEAD_COMPLETE_2}

# Edge Case Leads - Special Characters, International, etc.
@{EDGE_CASE_LEADS}
...    &{LEAD_EDGE_CASE_1}
...    &{LEAD_EDGE_CASE_2}


# =============================================================================
# MINIMAL LEAD - REQUIRED FIELDS ONLY
# =============================================================================

&{LEAD_MINIMAL}
...    last_name=Smith
...    company=Test Company Inc


# =============================================================================
# STANDARD LEADS - TYPICAL BUSINESS SCENARIOS
# =============================================================================

# Lead 1 - Website Inquiry (Open Status)
&{LEAD_STANDARD_1}
...    salutation=Ms.
...    first_name=Sarah
...    last_name=Johnson
...    company=Acme Corporation
...    title=VP of Sales
...    email=sarah.johnson@acme.com
...    phone=555-0101
...    mobile_phone=555-0201
...    website=www.acme.com
...    lead_status=New
...    lead_source=Website
...    rating=Warm
...    industry=Technology

# Lead 2 - Trade Show Contact (Working Status)
&{LEAD_STANDARD_2}
...    salutation=Mr.
...    first_name=Michael
...    last_name=Chen
...    company=TechStart Inc
...    title=Chief Technology Officer
...    email=michael.chen@techstart.com
...    phone=555-0102
...    mobile_phone=555-0202
...    website=www.techstart.com
...    lead_status=Working
...    lead_source=Trade Show
...    rating=Hot
...    industry=Technology
...    number_of_employees=150
...    annual_revenue=5000000

# Lead 3 - Partner Referral (Qualified)
&{LEAD_STANDARD_3}
...    salutation=Ms.
...    first_name=Emily
...    last_name=Rodriguez
...    company=Global Dynamics
...    title=Operations Director
...    email=emily.r@globaldynamics.com
...    phone=555-0103
...    mobile_phone=555-0203
...    fax=555-0303
...    website=www.globaldynamics.com
...    lead_status=Working
...    lead_source=Partner
...    rating=Hot
...    industry=Manufacturing
...    number_of_employees=500
...    annual_revenue=25000000

# Lead 4 - Webinar Attendee (New)
&{LEAD_STANDARD_4}
...    salutation=Dr.
...    first_name=David
...    last_name=Kim
...    company=Innovate Labs
...    title=Research Director
...    email=david.kim@innovatelabs.com
...    phone=555-0104
...    mobile_phone=555-0204
...    website=www.innovatelabs.com
...    lead_status=New
...    lead_source=Webinar
...    rating=Warm
...    industry=Biotechnology
...    number_of_employees=75


# =============================================================================
# COMPLETE LEADS - ALL FIELDS POPULATED
# =============================================================================

# Complete Lead 1 - Enterprise Prospect
&{LEAD_COMPLETE_1}
...    salutation=Mr.
...    first_name=Robert
...    last_name=Anderson
...    company=Enterprise Solutions Corp
...    title=Chief Information Officer
...    email=robert.anderson@enterprisesolutions.com
...    phone=555-0105
...    mobile_phone=555-0205
...    fax=555-0305
...    website=www.enterprisesolutions.com
...    street=500 Enterprise Parkway, Suite 200
...    city=New York
...    state=NY
...    postal_code=10001
...    country=USA
...    lead_status=Working
...    lead_source=Trade Show
...    rating=Hot
...    industry=Technology
...    number_of_employees=5000
...    annual_revenue=500000000
...    description=Met at annual tech conference. Very interested in enterprise solution. Follow up scheduled for next week. High priority prospect with immediate budget availability.
...    do_not_call=False
...    email_opt_out=False
...    fax_opt_out=False

# Complete Lead 2 - Healthcare Prospect
&{LEAD_COMPLETE_2}
...    salutation=Dr.
...    first_name=Jennifer
...    last_name=Martinez
...    company=HealthCare Innovations
...    title=Director of Medical Technology
...    email=j.martinez@healthcareinnovations.com
...    phone=555-0106
...    mobile_phone=555-0206
...    fax=555-0306
...    website=www.healthcareinnovations.com
...    street=1200 Medical Center Drive
...    city=Boston
...    state=MA
...    postal_code=02115
...    country=USA
...    lead_status=Working
...    lead_source=Partner
...    rating=Hot
...    industry=Healthcare
...    number_of_employees=1200
...    annual_revenue=75000000
...    description=Referred by existing customer. Looking to modernize patient management systems. Budget approved for Q4. Decision committee includes 5 stakeholders.
...    do_not_call=False
...    email_opt_out=False
...    fax_opt_out=True


# =============================================================================
# EDGE CASE LEADS - SPECIAL SCENARIOS
# =============================================================================

# Edge Case 1 - International Lead with Special Characters
&{LEAD_EDGE_CASE_1}
...    salutation=Ms.
...    first_name=Françoise
...    last_name=O'Brien-Müller
...    company=Société Européenne d'Innovation
...    title=Directrice Générale
...    email=f.obrien-muller@sei-europe.fr
...    phone=+33-1-55-55-55-55
...    mobile_phone=+33-6-55-55-55-55
...    website=www.sei-europe.fr
...    street=25 Avenue des Champs-Élysées
...    city=Paris
...    state=Île-de-France
...    postal_code=75008
...    country=France
...    lead_status=New
...    lead_source=Website
...    rating=Warm
...    industry=Consulting
...    number_of_employees=250
...    annual_revenue=15000000
...    description=International prospect from European market. Requires multi-language support and GDPR compliance discussion.

# Edge Case 2 - Long Names and Privacy Preferences
&{LEAD_EDGE_CASE_2}
...    salutation=Prof.
...    first_name=Alexander
...    last_name=Williamson-Smythe III
...    company=The Institute for Advanced Research and Development
...    title=Senior Vice President of Strategic Initiatives and Innovation
...    email=a.williamson-smythe@institute-ard.edu
...    phone=555-0108
...    website=www.institute-ard.edu
...    street=1000 University Research Boulevard, Building C, Floor 3
...    city=Cambridge
...    state=MA
...    postal_code=02138
...    country=USA
...    lead_status=New
...    lead_source=Advertisement
...    rating=Cold
...    industry=Education
...    number_of_employees=800
...    description=Academic institution with complex procurement process. Long sales cycle expected.
...    do_not_call=True
...    email_opt_out=False
...    fax_opt_out=True

You
31 Oct, 17:35
Convert this csv snippet into a list of dictionaries for use with CRT. Build this in the variables section if possiblelead_status,last_name,company,first_name,salutation,phone,title,email,website,lead_source
Open,Johnson,Acme Corporation,Sarah,Ms.,555-0101,VP of Sales,sarah.johnson@acme.com,www.acme.com,Website
Working,Chen,TechStart Inc,Michael,Mr.,555-0102,Chief Technology Officer,michael.chen@techstart.com,www.techstart.com,External Referral
Qualified,Rodriguez,Global Dynamics,Emily,Ms.,555-0103,Operations 