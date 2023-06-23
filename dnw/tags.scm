
(define-module (dnw tags)
  #:use-module (dnw theme)
  #:use-module (haunt post)
  #:use-module (srfi srfi-1)
  #:use-module (haunt html)
  #:use-module (haunt post)
  #:use-module (haunt page)
  #:use-module (haunt utils)
  #:use-module (ice-9 match)
  #:export (group-by-tag
	    count-tags
	    tag-uri
	    tags->page
	    tag-description
	    desc-alist))

(define (group-by-tag posts)
  "Given a lisp of haunt posts generate a list grouping tags with the
posts associated with it."
  (let ((table (make-hash-table)))
    (for-each (lambda (post)
                (let ((tags (post-ref post 'tags)))
                  (for-each (lambda (tag)
			      (let ((current (hash-ref table tag)))
                                (if current
                                    (hash-set! table tag (cons post current))
                                    (hash-set! table tag (list post)))))
                            tags)))
	      posts)
    (hash-fold alist-cons '() table)))


(define (count-tags posts)
  "Return a list of tags associated with their count in descending
order."
  (sort (map (lambda (tag)
	       (list (car tag) (length (cdr tag))))
             (group-by-tag posts))
        (lambda (a b) (> (cadr a) (cadr b)))))


(define (tag-uri tag)
  "Given a TAG return the page that contains only posts associated
with that TAG."
  (string-append "/posts/tag/" tag ".html"))


(define (tags->page site posts)
  (flat-map (match-lambda
	      ((tag . posts)
	       (make-page (tag-uri tag)
			  (base-template site (tags-template site posts #:title tag)
					 #:title tag)
			  sxml->html)))
	    (group-by-tag posts)))

(define (tag-description tag descalist)
  (let ((desc (assoc tag descalist)))
    (if desc
	`(p ,(cdr desc))
	'(p "No description."))))

(define desc-alist
  '(("Test" . "This is a test of the tag description feature.")))
