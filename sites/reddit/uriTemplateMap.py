#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit
# http://possibilistic.org
# echelon@gmail.com
# This code available under the GPL 3 unless otherwise noted.

from urlparse import urlparse

def uriTemplateMap(uri):
	"""Return the correct template matching the URI"""
	u = urlparse(uri)
	path = u.path + ("?" + u.query if u.query else "") + u.fragment
	if not path:
		path = '/'

	parts = path.split('/')

	if len(parts) >= 2 and not parts[1]:
		return "INDEX"

	if len(parts) >= 4 and parts[3] != 'comments':
		return "INDEX"

	if len(parts) >= 4 and parts[1] == 'r' and parts[3] == 'comments':
		return "COMMENTS"

	if len(parts) >= 3 and parts[1] == 'user':
		return "USER"

	return False

"""
== CHANNEL PAGES ==
	* http://www.reddit.com/
	* http://www.reddit.com/r/atheism/
	* http://www.reddit.com/r/programming/?count=25&after=t3_9v103

== COMMENT PAGES ==
	* http://www.reddit.com/r/programming/comments/9vb24/frequently_
	  asked_questions_for_progreddit/

== USER PAGES ==
	* http://www.reddit.com/user/eurleif

"""

if __name__ == '__main__':

	test = []
	uris.append("http://www.reddit.com")
	uris.append("http://www.reddit.com/r/atheism/")
	uris.append("http://www.reddit.com/r/programming/?count=25&after=t3_9v103")
	uris.append("http://www.reddit.com/r/programming/comments/9v36r/firefox_to_"
				"microsoft_gtfo/")
	uris.append("http://www.reddit.com/user/eurleif")

	for u in uris:
		print uriTemplateMap(u)

