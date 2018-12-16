Deploy PSBackup {
    By PSGalleryModule {
        FromSource "$PSScriptRoot\_output\PSBackup"
        To SFGallery
    }
}