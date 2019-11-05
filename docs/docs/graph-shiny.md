---
id: graph-shiny
title: graph-shiny
sidebar_label: graph-shiny
---

# `graph-shiny`

Shiny bindings for graph


## Description

Output and render functions for using graph within Shiny
 applications and interactive Rmd documents.


## Usage

```r
graphOutput(outputId, width = "100%", height = "400px")
renderGraph(expr, env = parent.frame(), quoted = FALSE)
render_graph(expr, env = parent.frame(), quoted = FALSE)
graphProxy(id, session = shiny::getDefaultReactiveDomain())
graph_proxy(id, session = shiny::getDefaultReactiveDomain())
```


## Arguments

Argument      |Description
------------- |----------------
`outputId, id`     |     output variable to read from
`width, height`     |     Must be a valid CSS unit (like `'100%'` , `'400px'` , `'auto'` ) or a number, which will be coerced to a string and have `'px'` appended.
`expr`     |     An expression that generates a graph
`env`     |     The environment in which to evaluate `expr` .
`quoted`     |     Is `expr` a quoted expression (with `quote()` )? This is useful if you want to save an expression in a variable.
`session`     |     A valid shiny session.


