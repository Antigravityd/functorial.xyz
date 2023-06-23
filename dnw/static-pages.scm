

(define-module (dnw static-pages)
  #:use-module (ice-9 match)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 popen)
  #:use-module (dnw utils)
  #:use-module (dnw theme)
  #:use-module (dnw tags)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-19)
  #:use-module (sxml simple)
  #:use-module (haunt page)
  #:use-module (haunt utils)
  #:use-module (haunt post)
  #:use-module (haunt html)
  #:export (index-page
	    me-page
	    friends-page
	    influences-page))

;; TODO: tags-template
;; building index-page
(define about
  `(section (@ (id "about"))
	    (div
	     (p "My name is Duncan. I live below the Mason-Dixon.")
	     (p "I write down thoughts I think are interesting here."))))

(define (recents site posts)
  `(section (@ (id "recent"))
	    (div
	     (h1 "Recent Posts"
		 ,(hyperlink "/feed.xml" (image "rss.png" "RSS Feed Icon" "rss-icon")))
	     (div (@ (class "post-listing"))
		  ,(map (lambda (post)
			  (post-header site post))
			(take-up-to 10 (posts/reverse-chronological posts))))
	     ,(hyperlink "/posts" "All Posts"))))

(define (index-content site posts)
  `(,about ,(recents site posts)))

(define (index-page site posts)
  (make-page "/index.html"
	     (base-template site (index-content site posts) #:title "Home ")
	     sxml->html))

(define me
  `((section (@ (id "addressbook"))
	     (ul (p "GPG: " ,(hyperlink "/assets/pubkey.txt" "A63B DBA0 B4FB 6EAB 1D1A 6665 029C EF3B A922 2674")))
	     (ul (p "Email: (rot13 \"qaj@shapgbevny.klm\")")
		 (p "Matrix: (rot13 \"synzvajnyehf@zngevk.bet\")")
		 (p "IRC: (rot13 \"SynzvaJnyehf@yvoren.pung\")"))
	     (ul (p "Nostr: npub1a706jyq9hljs08fsr7ejzr3g4l33fpwnadxp63hmjp6tshfvlcqs6z3w29"))
	     (ul (p "Github: " ,(hyperlink "https://github.com/Antigravityd" "Antigravityd")))) ;; TODO: consider moving to Sourcehut.
    (section (@ (id "prose"))
	     (h1 "About Me")
	     (p "My name is Duncan. I am 20, and have lived most of my life in rural Arkansas. I graduated in 2023 from LSU, cum laude, "
		"with dual degrees in math and physics, and have at various times been employed as a dishwasher, maintainence guy, tutor, "
		"data science intern, embedded developer, and research scientist. I am currently unemployed.")
	     (p "Had I my druthers, I would like to be able to make a career out of decentralized science, "
		"doing physics research and teaching not dependent on the state or the university system and their insidious pollution"
		"of the discipline. "
		"In the interim, I'm in no way above contributing to society more directly. Hire me; I'll learn anything. I have a "
		,(hyperlink "/assets/cv.pdf" "terrible CV") " you can read.")
	     (h1 "Academic Interests")
	     (h2 "Physical Science")
	     (p "I've planned on studying physics since I was 5. I enjoy studing almost anything that's natural and dead, "
		"and all my other interests are largely subsidiary to this. "
		"I like the areas where physics intersects with math, particularly when it does so in mathematically-exciting ways. "
		"I also " (emph "loved") " my classes about emergent phenomena: thermodynamic, statistical, and condensed-matter physics. "
		"I spent the latter half of my time working under Jeff Chancellor's Space Radiation Transport and Applied Nuclear Physics "
		"(SpaRTAN physics) research group, doing embedded design of radiation detectors and writing improvements for transport code.")
	     (h2 "Mathematics")
	     (p "I view math primarily as a tool for physical science and philosophy in general. "
		"Accordingly, I want to get to the frontier of the discipline as fast as possible: I probably will need to make new tools. "
		"The only domain that seems not to have borne much practical fruit, except as a " (emph "target") " for developing "
		"\"real\" tools, is number theory. "
		"However, I particularly like topology/geometry and algebra, and would prefer if analysis and discrete math borrowed "
		"as many of its tools and methods as possible.")
	     (h2 "Computation")
	     (p "Fundamentally, computer science is a branch of mathematics, in my view. "
		"I am interested in ways to compute as abstractly, efficiently, securely, and correctly as possible. "
		"As such, I enjoy functional and logic programming languages, which succeed by representing computation in maximally "
		"mathematical form, using the abstractions that have been most useful in a general context. "
		"I like writing things in Haskell and Lisp. I have written many things in Python, C, and Fortran. "
		"I didn't enjoy it (although Fortran was much better than expected—prefered to C). "
		"I would like to learn Rust to replace the latter two, and also Lean for formal verification of mathematics and programs. "
		"Julia as a scripting language is also intriguing, for projects consumed by people allergic to parentheses. "
		"Software that is not " ,(hyperlink "https://gnu.org/philosophy" "Free") " might as well not be software at all. "
		"I use GNU Emacs for almost everything.")
	     (h2 "Engineering")
	     (p "For all of the above, you have to build real, material things. "
		"Physical science requires the construction of detectors, accelerators, and whatnot; "
		"mathematics needs blackboards, chalk, printing presses, and a society to ignore; "
		"and computation needs computers and network technology. "
		"This is predominantly electrical work—designing silicon, circuits, wire protocols, radios, and so on. "
		"I've done a fair bit of this. "
		"However, that electrical work is predicated on things like power generation, structures to protect the electronics, etc. "
		"So, I aspire to learn \"real\" CAD at some point, and understand these things too. ")
	     (h2 "Praxeology")
	     (p "There simply is not enough time in a person's life for autarkic, first-principles generation of every part of every thing "
		"one's primary interests depend on. "
		"It is critically important to understand and verify those steps, but it is necessary to outsource their production. "
		"In order to understand the principles under which this outsourcing occurs, why it's even possible at all, "
		"and how it need not be vicious, one must study the category of action. "
		"Austrian economics, and more generally praxeology, does so correctly. "
		"The critical error of conventional economics, as with many social- and life-science disciplines, "
		"is thoughtless application of the methods of physical science, without careful consideration of whether the philosophical "
		"conditions the correctness of those methods depend are present. "
		"These fail spectacularly in analysis of action: the wants and desires of humans are not immutable, comparable quantities. "
		"However, Austrian economists tend to thoughtlessly reject methodological precision due to superficial association "
		"with these historical fallacies. "
		"A mathematical, in the truest sense, grounding for the reasoning of Mises, Rothbard, and Hoppe "
		"is a longstanding pet project of mine. ")
	     (h2 "Foundations: Philosophy and Theology")
	     (p "All of this again rests on some foundational definitions and propositions about the nature of reality, truth, reason, mind, "
		"beauty, and morality. "
		"Very recently, I've become acutely interested in these foundations, particularly the philosophy of mathematics and science. "
		"I am metaphysically an ardent platonist, and believe that analysis of the problem of perception in a platonist context "
		"contains parts identifiable with mathematics and science. "
		"This analysis, however, carries little further: I am attracted to methodological anarchy, which holds "
		"that there is no essential distinction between practice, philosophy, teaching, and history of science (and mathematics)."
		"Anything and everything there is fair game—and many scientific revolutions are the result of such foundational assaults.")
	     (p "That the philosophical tradition which created the modern world emerged almost exclusively out of Abrahamic religion, "
		"and that its sustaining manifestation is almost exclusively owed to Protestant Christians, carries tremedous weight with me."
		" I see no essential difference between these theological premises and philosophy, save methodology—"
		"the former implemented in story, and the latter rhetoric—and accordingly extend foundational interest to Christiandom.")
	     (h2 "Blind Spots")
	     (p "I don't know much about linguistics and aesthetics/art (save the mere verneer to which all men are exposed). "
		"These are similarly foundational, as philosophy can only be communicated through language, and must be bootstrapped "
		"by the beautiful (usually stories). "
		"I would like to learn these things, but am not taking active measures in any capacity to do so at the moment.")
	     (h1 "Anti-Interests")
	     (p "I dislike: OOP, Javascript, the Intel Management Engine, almost all TV and movies, number theory, measure theory, "
		"drugs, the War on Drugs, appeals to authority, the Federal Reserve System, occupational licensure, and collectivism.")
	     (h1 "Touching Grass")
	     (p "I listen to (.*)core, rock and metal from the 60s–80s, microtonal and avant-garde jazz and classical, and old standards. "
		"I all-too-seldom go outside: when I remember I enjoy it, I resistance train, hike, (spin|fly) fish, (snow|water) ski, "
		"climb, and mountaineer. "
		"I read high fantasy and sci-fi obsessively for about 10 years, and occasionally go back through "
		"the Tolkein, Jordan, and Sanderson novels I love. "
		"I watch a lot of football and baseball; my Tigers picked up a ring in each while I was there."))))


(define (me-page site posts)
  (make-page "/pages/me.html"
	     (base-template site me #:title "Me")
	     sxml->html))

(define friends
  `((h1 "Friends")
    (p "Blogs/websites of people and corporations I know firsthand, as friends, colleagues, or employers. ")
    (table
     (tbody
      (tr (td ,(hyperlink "https://atlantis-industries.com" "Atlantis Industries")) (td "Worked on retainer with them for a year."))
      (tr (td ,(hyperlink "https://spartanphysics.com/" "SpaRTAN Physics")) (td "Lab I spent half my undergrad in."))
      (tr (td ,(hyperlink "https://www.lsu.edu/physics/people/faculty/chancellor.php" "Jeff Chancellor"))
	  (td "My undergrad advisor, founder and CTO of Atlantis and director of SpaRTAN Physics."))))))

(define (friends-page site posts)
  (make-page "/pages/friends.html"
	     (base-template site friends #:title "Friends")
	     sxml->html))

(define influences
  `((h1 "Influences")
    (p "Anything and everything I can think of that's affected how I think. ")
    (h2 "Blogs")
    (h2 "Books and Monographs")
    (h2 "Scholarly Articles")
    (h2 "Videos and Talks")))

(define (influences-page site posts)
  (make-page "/pages/influences.html"
	     (base-template site influences #:title "Influences")
	     sxml->html))
