# OrderFulfillment

### Description

Contains details on how to fulfill this order.

## Properties
Name | Getter | Setter | Type | Description | Notes
------------ | ------------- | ------------- | ------------- | ------------- | -------------
**type** | getType() | setType($value) | **string** | The type of the fulfillment. See [OrderFulfillmentType](#type-orderfulfillmenttype) for possible values | [optional] 
**state** | getState() | setState($value) | **string** | The state of the fulfillment. See [OrderFulfillmentState](#type-orderfulfillmentstate) for possible values | [optional] 
**pickup_details** | getPickupDetails() | setPickupDetails($value) | [**\SquareConnect\Model\OrderFulfillmentPickupDetails**](OrderFulfillmentPickupDetails.md) | Contains pickup-specific details. Required when fulfillment type is &#x60;PICKUP&#x60;. | [optional] 

Note: All properties are protected and only accessed via getters and setters.

[[Back to Model list]](../../README.md#documentation-for-models) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to README]](../../README.md)

