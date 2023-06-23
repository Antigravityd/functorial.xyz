;; The main Haunt entry-point for my site.

(use-modules (haunt site)
	     (haunt post)
	     (haunt asset)
	     (haunt reader)
	     (haunt builder blog)
	     (haunt builder atom)
	     (haunt builder assets)
	     (haunt publisher rsync)
	     (dnw theme)
	     (dnw tags)
	     (dnw static-pages)
	     (srfi srfi-19)
             (srfi srfi-26))


(define (org-string->date str)
  "Convert STR, a string in Org format, into a SRFI-19 date object."
  (catch 'misc-error
    (lambda () (string->date str "<~Y-~m-~d ~a ~H:~M>"))
    (lambda (key . parameters) (string->date str "<~Y-~m-~d ~a>"))))

(register-metadata-parser! 'date org-string->date)

(site #:title "Through the Heart of Every Man"
      #:domain "functorial.xyz"
      #:default-metadata
      '((author . "Duncan Wilkie")
	(email  . "dnw@functorial.xyz"))
      #:readers (list html-reader)
      #:builders (list (blog
			#:theme dnw-haunt-theme
			#:prefix "/posts")
		       index-page
		       me-page
		       friends-page
		       influences-page
		       tags->page
		       (atom-feed #:blog-prefix "/posts")
		       (atom-feeds-by-tag)
		       (static-directory "assets"))
      #:publishers (list (rsync-publisher #:destination "/var/www/functorial"
					  #:user "publish"
					  #:host "functorial.xyz")))
