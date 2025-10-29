*** Settings ***
Library           QWeb
Resource          ../resources/common.resource
Resource          ../resources/Sales/leads.resource
Suite Setup       Setup Browser
Suite Teardown    Close All Browser Sessions

*** Test Cases ***
Create a Lead E2E
    Enter a Lead    New    Smith    Growmore    Tina    Ms.
    Delete a Lead          Tina     Smith