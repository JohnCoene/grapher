---
id: install
title: Installation
sidebar_label: Installation
---

grapher is not yet hosted on [CRAN](https://cran.r-project.org/) it will go through a thorough testing phase before being submitted. The code is hosted on [Github](http://github.com/JohnCoene/grapher) and can be installed using either `devtools` or `remotes`.

Some functions rely on Jeroen Ooms' [V8](https://github.com/jeroen/V8) package which require Google's V8 JavaScript installed, the installation instructions are clear, easy to run and available in the [README of V8](https://github.com/jeroen/V8). If you truly do not want to install V8 set the parameter `dependencies` to `c("Depends", "Imports")` in either `install_github` function below.

<!--DOCUSAURUS_CODE_TABS-->
<!--remotes-->
```r
install.packages("remotes", repos = "https://cran.rstudio.com")
remotes::install_github('JohnCoene/grapher')
```
<!--devtools-->
```r
install.packages("devtools", repos = "https://cran.rstudio.com")
devtools::install_github('JohnCoene/grapher')
```
<!--END_DOCUSAURUS_CODE_TABS-->

Note that throughout the documentation we do not explicitly load the package and assume you have it loaded in your environment.

```r
library(grapher)
```

If loading package as above worked fine you are good to go!
