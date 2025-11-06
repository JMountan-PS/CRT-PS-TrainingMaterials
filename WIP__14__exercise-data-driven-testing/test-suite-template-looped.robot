*** Settings ***
Resource                    ../resources/common.resource
Resource                    ../resources/Sales/leads.resource
Resource                    lead-data.resource
Suite Setup                 Setup Browser
Test Setup                  Run Keywords                Home
Suite Teardown              Close All Browser Sessions

*** Test Cases ***       
Looped Test Case Template
    [Template]              Create Verify and Delete Lead End to End
    FOR                     ${Lead}                     IN                     @{ALL_LEADS}
        ${Lead}[lead_status]                            ${Lead}[last_name]     ${Lead}[company]
        ...                 ${Lead}[first_name]         ${Lead}[salutation]
        ...                 ${Lead}[phone]              ${Lead}[title]
        ...                 ${Lead}[email]              ${Lead}[website]
        ...                 ${Lead}[lead_source]
    END

    

*** Keywords ***

Create Verify and Delete Lead End to End
    [Arguments]             ${lead_status}              ${last_name}           ${company}      ${first_name}    ${salutation}    ${phone}=${EMPTY}    ${title}=${EMPTY}    ${email}=${EMPTY}    ${website}=${EMPTY}    ${lead_source}=${EMPTY}
    TRY
        Log To Console      Step: Entering Lead - ${first_name} ${lastname} - ${lead_status}
        Enter a Lead        ${lead_status}              ${last_name}           ${company}      ${first_name}    ${salutation}    ${phone}             ${title}             ${email}             ${website}             ${lead_source}
        Log To Console      Step: Deleting Lead - ${first_name} ${lastname} - ${lead_status}
        Delete a Lead       ${first_name}               ${last_name}
    EXCEPT                  AS                          ${error}
        Log To Console      ${error}
    END