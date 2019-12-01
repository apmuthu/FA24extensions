# CatalogQuery

### Description

A query to be applied to a [SearchCatalogObjectsRequest](#type-searchcatalogobjectsrequest). Only one query field may be present.  Where an attribute name is required, it should be specified as the name of any field marked \"searchable\" from the structured data types for the desired result object type(s) ([CatalogItem](#type-catalogitem), [CatalogItemVariation](#type-catalogitemvariation), [CatalogCategory](#type-catalogcategory), [CatalogTax](#type-catalogtax), [CatalogDiscount](#type-catalogdiscount), [CatalogModifierList](#type-catalogmodifierlist), [CatalogModifier](#type-catalogmodifier)).  For example, a query that should return Items may specify attribute names from any of the searchable fields of the [CatalogItem](#type-catalogitem) data type, namely `\"name\"`, `\"description\"`, and `\"abbreviation\"`.

## Properties
Name | Getter | Setter | Type | Description | Notes
------------ | ------------- | ------------- | ------------- | ------------- | -------------
**sorted_attribute_query** | getSortedAttributeQuery() | setSortedAttributeQuery($value) | [**\SquareConnect\Model\CatalogQuerySortedAttribute**](CatalogQuerySortedAttribute.md) | A query that returns all objects, sorted by the given attribute. | [optional] 
**exact_query** | getExactQuery() | setExactQuery($value) | [**\SquareConnect\Model\CatalogQueryExact**](CatalogQueryExact.md) | A query that returns only objects for which the given (string-valued) attribute has the given case-insensitive value. | [optional] 
**prefix_query** | getPrefixQuery() | setPrefixQuery($value) | [**\SquareConnect\Model\CatalogQueryPrefix**](CatalogQueryPrefix.md) | A query that returns only objects for which the given (string-valued) attribute has the given case-insensitive prefix. | [optional] 
**range_query** | getRangeQuery() | setRangeQuery($value) | [**\SquareConnect\Model\CatalogQueryRange**](CatalogQueryRange.md) | A query that returns only objects for which the given (integer-valued) attribute lies in the given range. | [optional] 
**text_query** | getTextQuery() | setTextQuery($value) | [**\SquareConnect\Model\CatalogQueryText**](CatalogQueryText.md) | A query that returns only objects whose searchable attributes contain all of the given keywords as prefixes. For example, if a [CatalogItem](#type-catalogitem) contains attributes &#x60;{\&quot;name\&quot;: \&quot;t-shirt\&quot;}&#x60; and &#x60;{\&quot;description\&quot;: \&quot;Small, Purple\&quot;}&#x60;, it will be matched by the query &#x60;{\&quot;keywords\&quot;: [\&quot;shirt\&quot;, \&quot;sma\&quot;, \&quot;purp\&quot;]}&#x60;. | [optional] 
**items_for_tax_query** | getItemsForTaxQuery() | setItemsForTaxQuery($value) | [**\SquareConnect\Model\CatalogQueryItemsForTax**](CatalogQueryItemsForTax.md) | A query that returns all [CatalogItem](#type-catalogitem)s that have any of the given [CatalogTax](#type-catalogtax)es enabled. | [optional] 
**items_for_modifier_list_query** | getItemsForModifierListQuery() | setItemsForModifierListQuery($value) | [**\SquareConnect\Model\CatalogQueryItemsForModifierList**](CatalogQueryItemsForModifierList.md) | A query that returns all [CatalogItem](#type-catalogitem)s that have any of the given [CatalogModifierList](#type-catalogmodifierlist)s enabled. | [optional] 
**items_for_item_options_query** | getItemsForItemOptionsQuery() | setItemsForItemOptionsQuery($value) | [**\SquareConnect\Model\CatalogQueryItemsForItemOptions**](CatalogQueryItemsForItemOptions.md) | A query that returns all [CatalogItem](#type-catalogitem)s that have all of the given [CatalogItemOption](#type-catalogitemoption)s. | [optional] 
**item_variations_for_item_option_values_query** | getItemVariationsForItemOptionValuesQuery() | setItemVariationsForItemOptionValuesQuery($value) | [**\SquareConnect\Model\CatalogQueryItemVariationsForItemOptionValues**](CatalogQueryItemVariationsForItemOptionValues.md) | A query that returns all [CatalogItemVariation](#type-catalogitemvariations)s that have all of the given [CatalogItemOption](#type-catalogitemoption) values. | [optional] 

Note: All properties are protected and only accessed via getters and setters.

[[Back to Model list]](../../README.md#documentation-for-models) [[Back to API list]](../../README.md#documentation-for-api-endpoints) [[Back to README]](../../README.md)

