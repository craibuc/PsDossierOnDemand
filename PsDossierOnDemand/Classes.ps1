class FilterCondition {
    [string]$Field
    [ValidateSet('eq','neq','isempty','Isnotempty','Isnull','isnotnull','contains','doesnotcontain','startswith','endswith','gt','lt','gte','lte','asofdate','asoftoday','asoflastmonth','asoflastyear','asofyear','asofmonth','ytd','mtd','month','currentmonth','lastmonth','currentyear','lastyear','year','currentmonthnumber','lastweek')]
    [string]$Operator
    [object]$Value

    FilterCondition([string]$field, [string]$operator, [object]$value) {
        $this.Field = $field
        $this.Operator = $operator
        $this.Value = $value
    }
}

class Filter {
    [ValidateSet('and','or')]
    [string]$Logic
    [FilterCondition[]]$Filters

    Filter([string]$logic, [FilterCondition[]]$filters) {
        $this.Logic = $logic
        $this.Filters = $filters
    }
}

class OrderBy {
    [string]$Field
    [ValidateSet('asc','desc')]
    [string]$Dir

    OrderBy([string]$field, [string]$dir) {
        $this.Field = $field
        $this.Dir = $dir
    }
}

class Expand {
    [string]$Name
    [Expand[]]$Expands

    Expand([string]$name) {
        $this.Name = $name
    }
    Expand([string]$name,[Expand[]]$expands) {
        $this.Name = $name
        $this.Expands = $expands
    }
}

class Operation {
    [int]$Page
    [ValidateRange(1, 1000)]
    [int]$Amount
    [Filter]$Filter
    [OrderBy[]]$OrderBy
    [Expand[]]$Expands

    Operation([int]$page, [int]$amount, [Filter]$filter = $null, [OrderBy[]]$orderBy = $null, [Expand[]]$expands = $null) {
        $this.Page = $page
        $this.Amount = $amount
        $this.Filter = $filter
        $this.OrderBy = $orderBy
        $this.Expands = $expands
    }
}
