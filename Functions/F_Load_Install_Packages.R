# A function checking wether a package is installed, loading installed packages and 
# Installing not installed ones before loading them

load_install_packages = function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
  
  
}
