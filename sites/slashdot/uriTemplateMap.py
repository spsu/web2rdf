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

	if path == '/' or path[1:10] == 'index2.pl':
		return "page-index.xsl"

	if path[0:6] == '/story' or path[1:11] == 'article.pl':
		return "page-story.xsl"

	if path[1:12] == 'comments.pl':
		return "page-comments.xsl"

	if path[1] == '~':
		return "page-userprofile.xsl"

	return False

"""
	Notes on the types of URLs present within slashdot.
	TODO: Not an exhaustive list...
== INDEX PAGES ==
	* http://slashdot.org/
		* linux.slashdot.org
		* science.slashdot.org
		* books.slashdot.org
			etc...
	* http://slashdot.org/index2.pl?section=&color=green&index=1&view=stories&
	  duration=-1&startdate=20091017

== STORY PAGES ==
	* http://science.slashdot.org/story/09/10/17/1750224/Facial-Bones-Grown-From
	  -Fat-Derived-Stem-Cells
	* http://linux.slashdot.org/article.pl?sid=09/10/19/0155235

== COMMENTS-ONLY PAGES ==
	* http://science.slashdot.org/comments.pl?sid=1408355&=29781633

== USER PAGES ==
	* http://slashdot.org/~BrucePerens
"""

if __name__ == '__main__':

	test = []
	test.append("http://linux.slashdot.org")
	test.append("http://slashdot.org/index2.pl?section=&color=green&index=1&"
				"view=stories&duration=-1&startdate=20091017")
	test.append("http://science.slashdot.org/story/09/10/17/1750224/Facial-"
				"Bones-Grown-From-Fat-Derived-Stem-Cells")
	test.append("http://linux.slashdot.org/article.pl?sid=09/10/19/0155235")
	test.append("http://science.slashdot.org/comments.pl?sid=1408355&=29781633")
	test.append("http://slashdot.org/~BrucePerens")

	for t in test:
		print uriTemplateMap(t)
