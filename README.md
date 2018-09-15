# json2env
An R package that parses javascript object notation (JSON) formatted arguments into R environments.


## Motivation
Sometimes it is convenient for R-function arguments to be a JSON named list, rather than properly declared formals. For example: web applications where R is in a pipeline (possibly as an [Rserve](https://www.rforge.net/Rserve/) instance) with other web technologies that use JSON for passing information.

## Install

Install with the [devtools](https://cran.r-project.org/web/packages/devtools/index.html) package.
```{r}
devtools::install_github("msinjin/json2env")
```
## Usage
```{r}
library(json2env)
json_args <- '{"a" : 3, "b" : 4, "c" : 5}'

my_fun <- function(json_args, a = 1, b = 2, d = 6, replace = T) {
    json2env(json_args, replace = replace)
    print(c(a, b, c, d))
}
my_fun(json_args) # [1] 3 4 5 6
my_fun(json_args, replace = F) # [1] 1 2 5 6
```
Note that `json2env` does not have a return value and so does not need to be assigned (`<-`).
