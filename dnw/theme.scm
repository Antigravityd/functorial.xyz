

(define-module (dnw theme)
  #:use-module (ice-9 match)
  #:use-module (haunt site)
  #:use-module (haunt post)
  #:use-module (haunt utils)
  #:use-module (dnw utils)
  #:use-module (dnw tags)
  #:use-module (haunt builder blog)
  #:export (dnw-haunt-theme
	    base-template
	    post-header
	    tags-template))

(define stylesheets '("style.css"))

(define nav-bar-tabs '(("Me" "/pages/me.html")
		       ("Friends" "/pages/friends.html")
		       ("Influences" "/pages/influences.html")
		       ("Projects" "/posts/tag/Project.html")))

(define dnw-title "Through the Heart of Every Man")

(define header
  `(header
    ,(hyperlink "/" (image "combgeo.png" "home"))
    (h1 ,dnw-title)
    (nav (ul
	  ,@(map (lambda (tuple)
		   `(li ,(apply hyperlink (reverse tuple))))
		 nav-bar-tabs)))))

(define footer
  `(footer
    (div
     (p "© 2023 Duncan Wilkie")
     ,(image "by-sa.svg"
	     "Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) Logo"))
    (p "Unless otherwise specified, the text and images on this site are free culture works available under the "
       ,(hyperlink "https://creativecommons.org/licenses/by-sa/4.0/"
                   "Creative Commons Attribution Share-Alike 4.0 International")
       " license.")
    (p "This website is built with "
       ,(hyperlink "http://haunt.dthompson.us/" "Haunt")
       ", a static site generator written in "
       ,(hyperlink "https://gnu.org/software/guile" "Guile Scheme")
       ". The source code is available "
       ,(hyperlink "https://github.com/Antigravityd/functorial.xyz" "here")
       ".")))

(define* (base-template site body #:key title)
  `((doctype html)
    (html (@ (lang "en")))
    (head
     ,(if (null? title)
          `(title title)
          `(title ,(string-join (list title dnw-title) " — ")))
     (meta (@ (charset "utf-8")))
     (meta (@ (name "viewport")
	      (content "width=device-width, initial_scale=1")))
     ,@(map (lambda (file-name) (stylesheet file-name)) stylesheets)
     (meta (@ (name "HandheldFriendly") (content "True")))
     (meta (@ (name "author") (content "Duncan Wilkie")))
     (meta (@ (name "subject") (content "Ravings of a Madman")))
     (meta (@ (name "medium") (content "blog")))
     (meta (@ (name "og:title") (content ,title))))
    (body (@ (class ""))
	  ,header
	  ,body
	  ,footer)))

(define (post-header site post)
  `(div (@ (id "post"))
	(div (@ (class "title"))
	     (h2 ,(hyperlink (post-uri site post)
			     (post-ref post 'title))))
	(div  (@ (class "subtitle"))
	      (p ,(let ((tgs (post-ref post 'tags))
			(datestr (date->string* (post-date post))))
		   (if tgs
	               `(,(string-append datestr " | ")
			 (span (@ (class "tags"))
			     ,(map (lambda (tag)
				     `(span
				       ,(hyperlink (tag-uri tag) tag)
				       " "))
				   tgs)))
		       datestr))))))

(define* (tags-template site posts #:key title)
  `((section (@ (id "posts"))
	     (div (@ (class "container"))
		  (h1 "Tagged #" ,title)
		  ,(tag-description title desc-alist)
 		  (div (@ (class "post-listing"))
		       ,(map (lambda (post)
			       (post-header site post))
			     (posts/reverse-chronological posts)))))))

(define (collection-template site title posts prefix)
  `((section (@ (id "posts"))
	     (div (@ (class "container"))
		  (h1 "All Posts"
		      ,(hyperlink "/feed.xml" (image "rss.png" "RSS Feed Icon" "rss-icon")))
		  (div (@ (class "post-listing"))
		       ,(map (lambda (post) (post-header site post))
			     (posts/reverse-chronological posts)))))))

(define dnw-haunt-theme
  (theme #:name "Through the Heart of Every Man"
	 #:layout
	 (lambda (site title body)
	   (base-template
	    site body
	    #:title dnw-title))
	 #:collection-template collection-template))
