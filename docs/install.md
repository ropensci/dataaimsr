
AIMS DataPlatform R Client Installation
=======================================
[Back](index)

At this stage __AIMS DataPlatform R Client__ is not hosted on CRAN R package network.  An alternative method of installation is to use the R `devtools` package.

R `devtools` can be installed using the following command:

```
> install.packages("devtools")

```

After `devtools` has been installed the __AIMS DataPlatform R Client__ can be installed directly from GitHub using the following command:

```
> devtools::install_git("https://github.com/AIMS/data-platform-r")

```

This command will also install 2 dependencies `httr` and `jsonlite`.
