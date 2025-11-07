*** Settings ***
Resource                    ../resources/common.resource
Resource                    ../resources/Sales/leads.resource
Library          DataDriver
...              file=${CURDIR}../testdata/BulkLeadData.xlsx
...              sheet_name=BulkLeadData
...              encoding=utf-8
Suite Setup                 Setup Browser
Test Setup                  Home
Suite Teardown              Close All Browser Sessions
Test Template               Create Verify and Delete Lead End to End

*** Test Cases ***       
DataDriver - Creating a lead ${first_name} ${last_name} with ${company}
    

*** Keywords ***

Create Verify and Delete Lead End to End
    [Arguments]             ${lead_status}              ${last_name}           ${company}      ${first_name}    ${salutation}    ${phone}=${EMPTY}    ${title}=${EMPTY}    ${email}=${EMPTY}    ${website}=${EMPTY}    ${lead_source}=${EMPTY}
    TRY
        Log To Console      Step: Entering Lead - ${first_name} ${last_name} - ${lead_status}
        Enter a Lead        ${lead_status}              ${last_name}           ${company}      ${first_name}    ${salutation}    ${phone}             ${title}             ${email}             ${website}             ${lead_source}
        Log To Console      Step: Deleting Lead - ${first_name} ${last_name} - ${lead_status}
        Delete a Lead       ${first_name}               ${last_name}
    EXCEPT                  AS                          ${error}
        Log To Console      ${error}
    END 