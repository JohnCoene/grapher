---
id: affiliation_graph
title: Affiliation Graph
sidebar_label: Affiliation Graph
---

## Description

Create an affiliation graph from a user-community structure.


## Usage

```r
affiliation_graph(
  links,
  member,
  community,
  weight = NULL,
  seed = 42,
  coefficient = NULL,
  scale = NULL
)
```


## Arguments

Argument      |Description
------------- |----------------
`links`     |     A data.frame containing `member`  and `community` .
`member`     |     A person who is part of a `community` .
`community`     |     A community, e.g.: a mailing list, a news group, etc.
`seed`     |     A random seed for reproducibility.
`coefficient, scale, weight`     |     You can explicitly specify the strength of a membership. That is how strongly a given `member` belongs to a `community` . The higher the strength the more likely it is for a member to have connections with other members of the community. By default the function does not require you to specify strength for the affiliation graph. If you do not specify the strength, it is assumed that strength is equally distributed among community members, and its value will be: $strength = (numberOfCommunityMembers, -coefficient) ^ 2 * scale$ . You specify the very strength of each relationship ising the `weight`  column.


## Details

Note: setting weight to 0 will prohibit the model from building
 connections for this user within current community. It's same as just not
 including user into the community.


## Value

A data.frame of `member` links.


## See Also

[https://github.com/anvaka/ngraph.agmgen](official documentation)


## Examples

```r
data <- tibble::tribble(
~"user",     ~"group",
"user 0",     "group 1",
"user 1",     "group 1",
"user 2",     "group 1",
"user 1",     "group 2",
"user 2",     "group 2",
"user 3",     "group 2"
)

g <- affiliation_graph(data, user, group)
graph(g)

# with weight
data$strength <- runif(6, 1, 10)
affiliation_graph(data, user, group, weight = strength)
```


