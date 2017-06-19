# FA24extensions
FrontAccountingERP v2.4.x Extensions Repo

## Introduction

The default Extensions repo for the FrontAccounting (FA) Project is at:
`http://anonymous:password@repo.frontaccounting.eu/`

The repo for FA v2.4.x version is at:
`http://anonymous:password@repo.frontaccounting.eu/2.4/`

These FA extensions comprise:
* Charts
* Extensions
* Languages
* Themes

## Methods and Usage
* All extensions are archived using `ar` and have an `_init` folder having a `config` details file and SHA1 hashes in `file`.
* These files have been extracted and unarchived in plain text form (for code) / native binary formats (for images) here.
* FA Developers are encouraged to fork this project and add / update these extensions, providing pull requests here.
* The FA project devs can use this for preparing their new versions of pkg files for use within the FA web interface.
* FA users can update their modules with the changed files alone.
* Windows users can bulk unarchive zips using:
`FOR /R %a IN (*.zip) DO "C:\Program Files\7-Zip\7z.exe" x "%a" -y`
* [Online SHA1 Hash Generator](http://hash.online-convert.com/sha1-generator)

## Caveats
* This repo will be updated only when I have the time.
* Files here are provided without any warranty / claims / support whatsoever.
* All copyrights remain those of the respective authors / FA Project.
