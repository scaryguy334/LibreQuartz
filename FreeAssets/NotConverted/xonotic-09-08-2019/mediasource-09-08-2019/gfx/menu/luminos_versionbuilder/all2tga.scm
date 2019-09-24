;Converts image files to .tga
;In:  FilesIn (wildcard * possible)
;     Compress (using RLE algorithm, 0=no, 1=yes)
;Out: tga files with same name as input (overwrites tga input files)

(define (all2tga filesIn compress)
	(let*
        (
            (fileList (cadr (file-glob filesIn 1)))
        )

        (while (not (null? fileList))
            (let*
                (
                    (file (car fileList))
                    (image (car (gimp-file-load 1 file file)))
                    (drawable (car (gimp-image-get-active-layer image)))
                )

                ;Set extension to .tga
		        (set! file (car (strbreakup file ".")))
		        (set! file (string-append file ".tga")) 

                ;Save image as RLE compressed tga
		        (set! drawable (car (gimp-image-merge-visible-layers image 1)))
		        (file-tga-save 1 image drawable file file compress 0)
                (gimp-image-delete image)

                (set! fileList (cdr fileList))
            )
	    )
    )
)
