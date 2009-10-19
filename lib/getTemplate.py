#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit
# http://possibilistic.org
# echelon@gmail.com
# This code available under the GPL 3 unless otherwise noted.

"""
Very simple mechanism for getting the template we need from a URL.
"""

from sites.domainMap import domainMap

def getTemplate(uri):
	"""Get the filename of the template from the URI."""

	module = domainMap(uri)
	if not module:
		return False

	try:
		# XXX TODO NOTE: Very, very insecure code! You lazy bastard.
		imp = "from sites.%s.uriTemplateMap import uriTemplateMap" % module
		exec imp
	except ImportError:
		print "Could not import module %s" % module
		return False

	tpl = uriTemplateMap(uri)
	if not tpl:
		return False

	tpl = './sites/' + module + '/' + tpl
	return tpl

if __name__ == '__main__':

	print "Testing domainMap.py...\n"

	uris = []
	# == Slashdot ==
	uris.append("http://slashdot.org")
	uris.append("http://linux.slashdot.org/")
	uris.append("http://slashdot.org/index2.pl?section=&color=green&index=1&"
				"view=stories&duration=-1&startdate=20091017")
	uris.append("http://it.slashdot.org/story/09/10/19/0053207/The-Economics-of"
				"-Federal-Cloud-Computing-Analyzed")
	uris.append("http://linux.slashdot.org/article.pl?sid=09/10/19/0155235")
	uris.append("http://science.slashdot.org/comments.pl?sid=1408355&=29781633")
	uris.append("http://slashdot.org/~BrucePerens")

	# == Reddit ==
	uris.append("http://www.reddit.com")
	uris.append("http://www.reddit.com/r/atheism/")
	uris.append("http://www.reddit.com/r/programming/?count=25&after=t3_9v103")
	uris.append("http://www.reddit.com/r/programming/comments/9v36r/firefox_to_"
				"microsoft_gtfo/")
	uris.append("http://www.reddit.com/user/eurleif")


	i = 1
	for u in uris:
		print "%d) %s" %(i, u)
		xslt = getTemplate(u)
		print "\t%s\n" % xslt
		i+= 1

