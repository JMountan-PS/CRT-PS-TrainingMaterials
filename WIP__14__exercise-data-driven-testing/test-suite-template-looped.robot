*** Settings ***
Resource             ../resources/common.resource
Resource             ../resources/Sales/leads.resource
Suite Setup          Setup Browser
Test Setup           Run Keywords                Home
Suite Teardown       Close All Browser Sessions

# In this exercise we use the same salesforce scenario built with exercise 6 and 12.
*** Variables ***

*** Test Cases ***       
Looped Test Case Template
    [Template]    Create Verify and Delete Lead End to End    

Suite Template Testing - Tina Smith                                                           Working             Smith                          Growmore                   Tina           Ms.            555-0123           Sales Director           tina.smith@growmore.com        www.growmore.com           Website
Suite Template Testing - Joe Shmoe                                                            New                 Shmoe                          Tech Innovations           Joe            Mr.            555-0456           Product Manager          joe.shmoe@techinnovations.com  www.techinnovations.com    External Referral
Suite Template Testing - Sarah Johnson                                                        Nurturing           Johnson                        Global Solutions Inc       Sarah          Ms.            555-0789           VP of Operations         sarah.j@globalsolutions.com    www.globalsolutions.com    Trade Show
Suite Template Testing - Michael Chen                                                         Working             Chen                           DataCore Systems           Michael        Dr.            555-0234           Chief Technology Officer michael.chen@datacore.io       www.datacore.io            Partner
Suite Template Testing - Emily Rodriguez                                                      Unqualified         Rodriguez                      Apex Consulting            Emily          Mrs.           555-0891           Business Analyst         emily.r@apexconsult.com        www.apexconsult.com        Webinar



*** Keywords ***

Create Verify and Delete Lead End to End
    [Arguments]      ${lead_status}              ${last_name}    ${company}          ${first_name}    ${salutation}    ${phone}=${EMPTY}    ${title}=${EMPTY}    ${email}=${EMPTY}    ${website}=${EMPTY}    ${lead_source}=${EMPTY}
    Enter a Lead     ${lead_status}              ${last_name}    ${company}       ${first_name}    ${salutation}       ${phone}             ${title}             ${email}             ${website}             ${lead_source}
    Delete a Lead    ${first_name}               ${last_name}