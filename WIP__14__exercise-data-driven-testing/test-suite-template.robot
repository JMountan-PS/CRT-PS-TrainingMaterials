*** Settings ***
Resource             ../resources/common.resource
Resource             ../resources/Sales/leads.resource
Library              FakerLibrary
Suite Setup          Setup Browser
Test Setup           Run Keywords                Home            Unique Test Data
Suite Teardown       Close All Browser Sessions
Test Template        Create Verify and Delete Lead End to End

# In this exercise we use the same salesforce scenario built with exercise 6 and 12.

*** Test Cases ***                                                                            lead_status         last_name                      company                    first_name     salutation     Phone              Title                    email                          website                    lead_source
Suite Template Testing - Tina Smith                                                           Working             Smith                          Growmore                   Tina           Ms.            555-0123           Sales Director           tina.smith@growmore.com        www.growmore.com           Web
Suite Template Testing - Joe Shmoe                                                            Open                Shmoe                          Tech Innovations           Joe            Mr.            555-0456           Product Manager          joe.shmoe@techinnovations.com  ${EMPTY}                   Referral
Suite Template Testing - Sarah Johnson                                                        Qualified           Johnson                        Global Solutions Inc       Sarah          Ms.            555-0789           VP of Operations         sarah.j@globalsolutions.com    www.globalsolutions.com    Trade Show
Suite Template Testing - Michael Chen                                                         Working             Chen                           DataCore Systems           Michael        Mr.            555-0234           Chief Technology Officer michael.chen@datacore.io       www.datacore.io            Partner Referral
Suite Template Testing - Emily Rodriguez                                                      Open                Rodriguez                      Apex Consulting            Emily          Mrs.           ${EMPTY}           Business Analyst         emily.r@apexconsult.com        www.apexconsult.com        ${EMPTY}


*** Keywords ***

Create Verify and Delete Lead End to End
    [Arguments]      ${lead_status}              ${last_name}    ${company}          ${first_name}    ${salutation}    ${phone}=${EMPTY}    ${title}=${EMPTY}    ${email}=${EMPTY}    ${website}=${EMPTY}    ${lead_source}=${EMPTY}
    Enter a Lead     ${lead_status}              ${last_name}    ${company}          ${salutation}    ${first_name}    ${phone}             ${title}             ${email}             ${website}             ${lead_source}
    Delete a Lead    ${first_name}               ${last_name}

