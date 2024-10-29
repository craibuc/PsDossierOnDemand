# Search and Select Operation

Most endpoints that return data from the API support Search and Select as a query parameter called `operation`. The `operation`’s value is a base-64 encoded JSON representation of what will be performed on the data.

## Paging
There are two properties within the JSON that describe what page of data and how many results to return. The maximum number of results from a given API call is 1000 items.

The basic structure of paging has the following 2 properties:

- page: specifies the page to be returned.
- amount: specifies the amount of data to return per page.

```json
{
    "page":1,
    "amount":10
}
```
The above example would load the first 10 items from the database.

## Filter
The API allows for a hierarchical structure to define filtering of data. The basic structure of a filter has the following properties:

- `field`: This is the name of the field to be filtered. For fields on a child property a dot delimiter is used in between property names. For example: `assetType.type`
- `operator`: The operator defines what type of filter you want to apply. The operators supported as of the writing of this document are defined below.
- `value`: This is the value that will be used in conjunction with the operator to filter on.  Not all operators support a value.

Within the operation we allow for multiple filters and therefore must define a collection of filters within the JSON. Each collection of “filters” has a “logic” property which can be set to `and` or `or`. This logic operator will be used for all “filter” objects within the “filters”
collection. Each “filter” object can also have a “logic” property and a child “filters” collection.

A basic filter can be seen below. In this example we will filter on results where the `primaryAssetID` equals "101".

```json
{
    "page": 1,
    "amount": 10,
    "filters": [
        {
            "logic": "and",
            "filter": {
                "field": "primaryAssetID",
                "operator": "eq",
                "value": "101"
            }
        }
    ]
}
```

### Operators

The following operators are supported within the API:

- `eq`: will filter results to the specific value specified in the `value` field
- `neq`: will filter results to everything but what is specified in the `value` field”
- `isempty`: will filter results that have an empty value. The `value` field is ignored
- `Isnotempty`: will filter results that do not have an empty value. The `value` field is ignored
- `Isnull`: will filter results that have a null value. The `value` field is ignored
- `isnotnull`: will filter results that do not have a null value. The `value` field is ignored
- `contains`: will filter results where the specified “field” contains the `value`
- `doesnotcontain`: will filter results where the specified “field” does not contains the `value`
- `startswith`: will filter results where the specified “field” starts with the `value`
- `endswith`: will filter results where the specified “field” ends with the `value`
- `gt`: will filter results where the specified “field” is greater than the `value`
- `lt`: will filter results where the specified “field” is less than the `value`
- `gte`: will filter results where the specified “field” is greater than and equal to the `value`
- `lte`: will filter results where the specified “field” is less than and equal to the `value`
- `asofdate`: will filter the results up through the specified date in the `value`. Only date fields are supported.
- `asoftoday`: will filter the results up through today’s date. Only date fields are supported.
- `asoflastmonth`: will filter the results up through the last day of last month. Only date fields are supported.
- `asoflastyear`: will filter the results up through the last day of last year. Only date fields are supported.
- `asofyear`: will filter the results up through the last day of the year specified. Only date fields are supported.
- `asofmonth`: will filter the results up through the last day of the month specified. Only date fields are supported.
- `ytd`: will filter the results from the first of the year through the current date. Only date fields are supported.
- `mtd`: will filter the results from the first of the month through the current date. Only date fields are supported.
- `month`: will filter the results to the month specified. Only date fields are supported.
- `currentmonth`: will filter the results to the current month only
- `lastmonth`: will filter the results to last month only. Only date fields are supported.
- `currentyear`: will filter the results to the current year only. Only date fields are supported.
- `lastyear`: will filter the results to last year only. Only date fields are supported.
- `year`: will filter the results to the year specified
- `currentmonthnumber`: will filter the results to the month number, 1 through 12. Only date fields are supported.
- `lastweek`: will filter the results to last week. Only date fields are supported.

## Sorting

The operation allows for sorting by one or more fields. The sort is performed by the order of fields specified within the `orderBy` collection. 

In the following example we will sort by `primaryAssetIdentifier` and then by `assetType.type`. You can also specify the direction with the `dir` property.  It can be either `asc` for ascending or `desc` for descending.

```json
{
    "page": 1,
    "amount": 10,
    "orderBy": [
        {
            "field": "primaryAssetIdentifier",
            "dir": "asc"
        },
        {
            "field": "assetType.type",
            "dir": "asc"
        }
    ]
}
```

## Grouping
To be defined later

## Aggregates
To be defined later

## Expanding

Expanding allows for inclusion of one or more related objects. For example: if the intent is to load `Assets`, but the `Asset`’s `Site` needs to be included you would do that by “expanding” on that property.

The following example expands both the `Site` and `AssetType` related objects, using `Asset` as
an example.

```json
{
    "page": 1,
    "amount": 10,
    "expands": [
        {
            "name": "Site"
        },
        {
            "name": "AssetType"
        }
    ]
}
```

The `name` is the name of the related object to include in the results. 

Expanding also supports a hierarchy. A hierarchy of items to expand upon can be defined with a dot delimited notation or a hierarchy of “expands” collections. 

The following two examples will both load the `Site` and the `Site`’s `Organizational Unit`. They are functional equivalents.

```json
{
    "page": 1,
    "amount": 10,
    "expands": [
        {
            "name": "Site.OrganizationalUnit"
        }
    ]
}
```
```json
{
    "page": 1,
    "amount": 10,
    "expands": [
        {
            "name": "Site",
            "expands": [
                {
                "name": "OrganizationalUnit"
                }
            ]
        }
    ]
}
```