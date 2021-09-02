# Setting up RStudio to automatically allow pushing to GitHub as long as you are on this computer...

# install the usethis package (automates repetitive meta-tasks)
install.packages("usethis")

# Set up your GitHub credentials
gitcreds::gitcreds_set() # enter your GitHub personal access token (PAT) below
usethis::git_vaccinate() # helps prevent you from leaking personal info to GitHub

# Note: anyone with access to your computer can make changes to your GitHub repositories, so be aware

# Check your configuration
gh::gh_whoami()
usethis::git_sitrep()


