*** Settings ***
Resource    common.resource
Library     RequestsLibrary
Library     Collections
Library     String


*** Variables ***
# Microsoft Graph API Base URL
${graph-api-base-url-copado}    https://graph.microsoft.com/v1.0
${graph-auth-url-copado}        https://login.microsoftonline.com

# Suite-level variables for token management
${outlook-access-token-copado}    ${EMPTY}


*** Keywords ***
authenticate-outlook-api-copado
    [Documentation]    Authenticates to Microsoft Graph API using OAuth 2.0 Client Credentials Flow
    ...                and stores the access token for subsequent API calls.
    ...                Requires: ${outlook-tenant-id-copado}, ${outlook-client-id-copado}, ${outlook-client-secret-copado}
    ...                Returns: Access token string
    [Tags]    outlook    authentication    api
    
    # Construct the OAuth token endpoint
    ${token-endpoint-copado}=    Set Variable    ${graph-auth-url-copado}/${outlook-tenant-id-copado}/oauth2/v2.0/token
    
    # Prepare the request body for client credentials flow
    &{auth-body-copado}=    Create Dictionary
    ...    client_id=${outlook-client-id-copado}
    ...    client_secret=${outlook-client-secret-copado}
    ...    scope=https://graph.microsoft.com/.default
    ...    grant_type=client_credentials
    
    # Make the authentication request
    ${auth-response-copado}=    POST
    ...    url=${token-endpoint-copado}
    ...    data=&{auth-body-copado}
    ...    expected_status=200
    
    # Extract and store the access token
    ${token-data-copado}=    Set Variable    ${auth-response-copado.json()}
    ${outlook-access-token-copado}=    Get From Dictionary    ${token-data-copado}    access_token
    Set Suite Variable    ${outlook-access-token-copado}
    
    Log To Console    Successfully authenticated to Microsoft Graph API
    [Return]    ${outlook-access-token-copado}


get-outlook-auth-headers-copado
    [Documentation]    Creates and returns the authorization headers required for Microsoft Graph API calls.
    ...                Ensures authentication token exists, authenticates if needed.
    ...                Returns: Dictionary containing Authorization header
    [Tags]    outlook    authentication    headers
    
    # Authenticate if token is not set
    ${token-empty-copado}=    Run Keyword And Return Status    Should Be Empty    ${outlook-access-token-copado}
    Run Keyword If    ${token-empty-copado}    authenticate-outlook-api-copado
    
    # Create headers dictionary
    &{headers-copado}=    Create Dictionary
    ...    Authorization=Bearer ${outlook-access-token-copado}
    ...    Content-Type=application/json
    
    [Return]    &{headers-copado}


read-outlook-messages-copado
    [Documentation]    Retrieves email messages from the specified user's mailbox.
    ...                Optional filters: top (number of messages), filter (OData filter), select (specific fields)
    ...                Returns: List of message objects
    [Arguments]    ${user-email-copado}=${outlook-user-email-copado}    ${top-copado}=10    ${filter-copado}=${EMPTY}    ${select-copado}=${EMPTY}
    [Tags]    outlook    email    read    messages
    
    # Get authentication headers
    &{headers-copado}=    get-outlook-auth-headers-copado
    
    # Construct the API endpoint
    ${messages-endpoint-copado}=    Set Variable    ${graph-api-base-url-copado}/users/${user-email-copado}/messages
    
    # Build query parameters
    &{params-copado}=    Create Dictionary    $top=${top-copado}
    
    # Add optional filter parameter
    ${filter-not-empty-copado}=    Run Keyword And Return Status    Should Not Be Empty    ${filter-copado}
    Run Keyword If    ${filter-not-empty-copado}    Set To Dictionary    ${params-copado}    $filter=${filter-copado}
    
    # Add optional select parameter
    ${select-not-empty-copado}=    Run Keyword And Return Status    Should Not Be Empty    ${select-copado}
    Run Keyword If    ${select-not-empty-copado}    Set To Dictionary    ${params-copado}    $select=${select-copado}
    
    # Make the API request
    ${messages-response-copado}=    GET
    ...    url=${messages-endpoint-copado}
    ...    headers=&{headers-copado}
    ...    params=&{params-copado}
    ...    expected_status=200
    
    # Extract messages from response
    ${response-data-copado}=    Set Variable    ${messages-response-copado.json()}
    ${messages-list-copado}=    Get From Dictionary    ${response-data-copado}    value
    
    ${message-count-copado}=    Get Length    ${messages-list-copado}
    Log To Console    Retrieved ${message-count-copado} messages from ${user-email-copado}
    
    [Return]    ${messages-list-copado}


read-specific-outlook-message-copado
    [Documentation]    Retrieves a specific email message by its ID.
    ...                Returns: Message object with full details
    [Arguments]    ${message-id-copado}    ${user-email-copado}=${outlook-user-email-copado}
    [Tags]    outlook    email    read    message
    
    # Get authentication headers
    &{headers-copado}=    get-outlook-auth-headers-copado
    
    # Construct the API endpoint for specific message
    ${message-endpoint-copado}=    Set Variable    ${graph-api-base-url-copado}/users/${user-email-copado}/messages/${message-id-copado}
    
    # Make the API request
    ${message-response-copado}=    GET
    ...    url=${message-endpoint-copado}
    ...    headers=&{headers-copado}
    ...    expected_status=200
    
    ${message-data-copado}=    Set Variable    ${message-response-copado.json()}
    
    Log To Console    Retrieved message: ${message-data-copado}[subject]
    
    [Return]    ${message-data-copado}


send-outlook-email-copado
    [Documentation]    Sends an email message from the specified user's mailbox.
    ...                Required: recipient-email, subject, body-content
    ...                Optional: cc-recipients (list), bcc-recipients (list), body-type (HTML or Text)
    ...                Returns: Response status (204 = success)
    [Arguments]    ${recipient-email-copado}    ${subject-copado}    ${body-content-copado}    
    ...            ${user-email-copado}=${outlook-user-email-copado}    ${cc-recipients-copado}=${EMPTY}    
    ...            ${bcc-recipients-copado}=${EMPTY}    ${body-type-copado}=HTML
    [Tags]    outlook    email    send    message
    
    # Get authentication headers
    &{headers-copado}=    get-outlook-auth-headers-copado
    
    # Construct recipient object
    &{to-recipient-copado}=    Create Dictionary    address=${recipient-email-copado}
    &{to-email-address-copado}=    Create Dictionary    emailAddress=&{to-recipient-copado}
    @{to-recipients-list-copado}=    Create List    &{to-email-address-copado}
    
    # Construct message body
    &{email-body-copado}=    Create Dictionary    contentType=${body-type-copado}    content=${body-content-copado}
    
    # Build the message object
    &{message-copado}=    Create Dictionary
    ...    subject=${subject-copado}
    ...    body=&{email-body-copado}
    ...    toRecipients=@{to-recipients-list-copado}
    
    # Add CC recipients if provided
    ${cc-not-empty-copado}=    Run Keyword And Return Status    Should Not Be Empty    ${cc-recipients-copado}
    Run Keyword If    ${cc-not-empty-copado}    add-cc-recipients-copado    ${message-copado}    ${cc-recipients-copado}
    
    # Add BCC recipients if provided
    ${bcc-not-empty-copado}=    Run Keyword And Return Status    Should Not Be Empty    ${bcc-recipients-copado}
    Run Keyword If    ${bcc-not-empty-copado}    add-bcc-recipients-copado    ${message-copado}    ${bcc-recipients-copado}
    
    # Wrap message in sendMail request body
    &{send-mail-body-copado}=    Create Dictionary    message=&{message-copado}    saveToSentItems=true
    
    # Construct the API endpoint
    ${send-mail-endpoint-copado}=    Set Variable    ${graph-api-base-url-copado}/users/${user-email-copado}/sendMail
    
    # Make the API request
    ${send-response-copado}=    POST
    ...    url=${send-mail-endpoint-copado}
    ...    headers=&{headers-copado}
    ...    json=&{send-mail-body-copado}
    ...    expected_status=202
    
    Log To Console    Email sent successfully to ${recipient-email-copado}
    
    [Return]    ${send-response-copado.status_code}


create-outlook-draft-copado
    [Documentation]    Creates a draft email message in the specified user's mailbox.
    ...                Required: recipient-email, subject, body-content
    ...                Optional: body-type (HTML or Text)
    ...                Returns: Draft message object with ID
    [Arguments]    ${recipient-email-copado}    ${subject-copado}    ${body-content-copado}    
    ...            ${user-email-copado}=${outlook-user-email-copado}    ${body-type-copado}=HTML
    [Tags]    outlook    email    draft    create
    
    # Get authentication headers
    &{headers-copado}=    get-outlook-auth-headers-copado
    
    # Construct recipient object
    &{to-recipient-copado}=    Create Dictionary    address=${recipient-email-copado}
    &{to-email-address-copado}=    Create Dictionary    emailAddress=&{to-recipient-copado}
    @{to-recipients-list-copado}=    Create List    &{to-email-address-copado}
    
    # Construct message body
    &{email-body-copado}=    Create Dictionary    contentType=${body-type-copado}    content=${body-content-copado}
    
    # Build the draft message object
    &{draft-message-copado}=    Create Dictionary
    ...    subject=${subject-copado}
    ...    body=&{email-body-copado}
    ...    toRecipients=@{to-recipients-list-copado}
    
    # Construct the API endpoint
    ${messages-endpoint-copado}=    Set Variable    ${graph-api-base-url-copado}/users/${user-email-copado}/messages
    
    # Make the API request
    ${draft-response-copado}=    POST
    ...    url=${messages-endpoint-copado}
    ...    headers=&{headers-copado}
    ...    json=&{draft-message-copado}
    ...    expected_status=201
    
    ${draft-data-copado}=    Set Variable    ${draft-response-copado.json()}
    ${draft-id-copado}=    Get From Dictionary    ${draft-data-copado}    id
    
    Log To Console    Draft created successfully with ID: ${draft-id-copado}
    
    [Return]    ${draft-data-copado}


search-outlook-messages-copado
    [Documentation]    Searches for email messages using a search query.
    ...                Uses Microsoft Graph search syntax.
    ...                Example query: "from:sender@example.com AND subject:invoice"
    ...                Returns: List of matching message objects
    [Arguments]    ${search-query-copado}    ${user-email-copado}=${outlook-user-email-copado}    ${top-copado}=25
    [Tags]    outlook    email    search    messages
    
    # Get authentication headers
    &{headers-copado}=    get-outlook-auth-headers-copado
    
    # Construct the API endpoint
    ${messages-endpoint-copado}=    Set Variable    ${graph-api-base-url-copado}/users/${user-email-copado}/messages
    
    # Build query parameters with search
    &{params-copado}=    Create Dictionary    $search=${search-query-copado}    $top=${top-copado}
    
    # Make the API request
    ${search-response-copado}=    GET
    ...    url=${messages-endpoint-copado}
    ...    headers=&{headers-copado}
    ...    params=&{params-copado}
    ...    expected_status=200
    
    # Extract messages from response
    ${response-data-copado}=    Set Variable    ${search-response-copado.json()}
    ${messages-list-copado}=    Get From Dictionary    ${response-data-copado}    value
    
    ${message-count-copado}=    Get Length    ${messages-list-copado}
    Log To Console    Found ${message-count-copado} messages matching: ${search-query-copado}
    
    [Return]    ${messages-list-copado}


reply-to-outlook-message-copado
    [Documentation]    Sends a reply to a specific email message.
    ...                Required: message-id, reply-content
    ...                Optional: reply-all (true/false)
    ...                Returns: Response status (202 = success)
    [Arguments]    ${message-id-copado}    ${reply-content-copado}    
    ...            ${user-email-copado}=${outlook-user-email-copado}    ${reply-all-copado}=false
    [Tags]    outlook    email    reply    message
    
    # Get authentication headers
    &{headers-copado}=    get-outlook-auth-headers-copado
    
    # Determine reply endpoint (reply vs reply-all)
    ${reply-action-copado}=    Set Variable If    '${reply-all-copado}'=='true'    replyAll    reply
    ${reply-endpoint-copado}=    Set Variable    ${graph-api-base-url-copado}/users/${user-email-copado}/messages/${message-id-copado}/${reply-action-copado}
    
    # Construct reply body
    &{reply-body-copado}=    Create Dictionary    comment=${reply-content-copado}
    
    # Make the API request
    ${reply-response-copado}=    POST
    ...    url=${reply-endpoint-copado}
    ...    headers=&{headers-copado}
    ...    json=&{reply-body-copado}
    ...    expected_status=202
    
    Log To Console    Reply sent successfully to message ID: ${message-id-copado}
    
    [Return]    ${reply-response-copado.status_code}


# Helper Keywords (Internal Use)

add-cc-recipients-copado
    [Documentation]    Internal helper to add CC recipients to a message object
    [Arguments]    ${message-dict-copado}    ${cc-list-copado}
    [Tags]    outlook    helper    internal
    
    @{cc-recipients-copado}=    Create List
    FOR    ${cc-email-copado}    IN    @{cc-list-copado}
        &{cc-recipient-copado}=    Create Dictionary    address=${cc-email-copado}
        &{cc-email-address-copado}=    Create Dictionary    emailAddress=&{cc-recipient-copado}
        Append To List    ${cc-recipients-copado}    ${cc-email-address-copado}
    END
    Set To Dictionary    ${message-dict-copado}    ccRecipients=@{cc-recipients-copado}


add-bcc-recipients-copado
    [Documentation]    Internal helper to add BCC recipients to a message object
    [Arguments]    ${message-dict-copado}    ${bcc-list-copado}
    [Tags]    outlook    helper    internal
    
    @{bcc-recipients-copado}=    Create List
    FOR    ${bcc-email-copado}    IN    @{bcc-list-copado}
        &{bcc-recipient-copado}=    Create Dictionary    address=${bcc-email-copado}
        &{bcc-email-address-copado}=    Create Dictionary    emailAddress=&{bcc-recipient-copado}
        Append To List    ${bcc-recipients-copado}    ${bcc-email-address-copado}
    END
    Set To Dictionary    ${message-dict-copado}    bccRecipients=@{bcc-recipients-copado}