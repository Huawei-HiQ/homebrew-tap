# Packaging for Mac OS (Homebrew)

This repository contains the code necessary to build and use packages for Mac OS using Homebrew.

## Environment setup

In order to use the formulas contained in this repository, you need to add a new tap to Homebrew. The command you need to run is

	brew tap huawei/hiq <url-or-path>

where you need to replace `<url-or-path>` with the URL or path of the present repository. If you have cloned this repository locally on your machine, you can use the path to the root folder

	brew tap huawei/hiq /path/to/hiq-deployment

If you are stuck, the webpage https://docs.brew.sh/Taps has more details about taps in Homebrew.

## Install the package

Once you have properly setup the tap, installing the packages is as simple as issuing the following command

	brew install huawei/hiq/hiq-projectq
