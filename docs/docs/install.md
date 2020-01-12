---
id: install
title: Installation
sidebar_label: Installation
---

grapher is not yet on [CRAN](https://cran.r-project.org/), it will have go through a thorough testing phase before being submitted, its functions and installation are continuously tested on Linux, Mac and Windows. The code is hosted on [Github](http://github.com/JohnCoene/grapher) and can be installed using either `devtools` or `remotes`.

Some functions rely on Jeroen Ooms' [V8](https://github.com/jeroen/V8) package which requires Google's V8 JavaScript engine installed, the installation instructions are available in the [README of V8](https://github.com/jeroen/V8) and below. If you do not want to install V8 skip this step but that is not recommended.

<!--DOCUSAURUS_CODE_TABS-->
<!--Debian/Ubuntu-->
```bash
sudo apt-get install -y libv8-dev
```
<!--Fedora-->
```bash
sudo yum install v8-devel
```
<!--CentOS-->
```bash
sudo yum install epel-release
sudo yum install v8-devel
```
<!--Homebrew-->
```bash
brew install v8
```
<!--END_DOCUSAURUS_CODE_TABS-->

Then run the following to install the package.

<!--DOCUSAURUS_CODE_TABS-->
<!--remotes-->
```r
install.packages("remotes", repos = "https://cran.rstudio.com")
remotes::install_github('JohnCoene/grapher', dependencies = c("Depends", "Imports"))
```
<!--devtools-->
```r
install.packages("devtools", repos = "https://cran.rstudio.com")
devtools::install_github('JohnCoene/grapher', dependencies = c("Depends", "Imports"))
```
<!--END_DOCUSAURUS_CODE_TABS-->

Note that throughout the documentation we do not explicitly load the package and assume you have it loaded in your environment.

```r
library(grapher)
```

If loading package as above worked fine you are good to go!
