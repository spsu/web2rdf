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
	uris.append("http://it.slashdot.org/story/09/10/19/0053207/The-Economics-of"
				"-Federal-Cloud-Computing-Analyzed")
	uris.append("http://linux.slashdot.org/")

	i = 1
	for u in uris:
		print "%d) %s" %(i, u)
		xslt = getTemplate(u)
		print "\t%s\n" % xslt
		i+= 1

