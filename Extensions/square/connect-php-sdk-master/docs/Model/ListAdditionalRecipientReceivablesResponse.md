# ListAdditionalRecipientReceivablesResponse

### Description

Defines the fields that are included in the response body of a request to the ListAdditionalRecipientReceivables endpoint.  One of `errors` or `additional_recipient_receivables` is present in a given response (never both).

## Properties
Name | Getter | Setter | Type | Description | Notes
------------ | ------------- | ------------- | ------------- | ------------- | -------------
**errors** | getErrors() | setErrors($value) | [**\SquareConnect\Model\Error[]**](Error.md) | Any errors that occurred during the request. | [optional] 
**receivables** | getReceivables() | setReceivables($value) | [**\SquareConnect\Model\AdditionalRecipientReceivable[]**](AdditionalRecipientReceivable.md) | An array of AdditionalRecipientReceivables that match your query. | [optional] 
**cursor** | getCursor() | setCursor($value) | **string** | A pagination cursor for retrieving the next set of results, if any remain. Provide this value as the &#x60;cursor&#x60; parameter in a subsequent request to this endpoint.  See [Pagination](/basics/api101/pagination) for more information. | [optional] 

Note: All properties are protected and only accessed via getters and setters.

[[Back to Model list]](../../README.md#documentation-for-models) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to README]](../../README.md)

