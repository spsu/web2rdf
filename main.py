#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit
# http://possibilistic.org
# echelon@gmail.com
# This code available under the GPL 3 unless otherwise noted.

from lib.WebTransform import WebTransform
from lib.getTemplate import getTemplate
from lib.fixUri import fixUri
from lib.CacheMap import CacheMap
import sys


def transform(uri, rdfOut = './cache.rdf'):
	"""Load the source and attempt to find the transform template."""

	uri = fixUri(uri)

	# Get template
	tplFile = getTemplate(uri)
	if not tplFile:
		print "Could not find matching template file for the URI."
		print "Uri was %s" % uri
		return False

	wt = WebTransform(uri)

	# Cache logic
	cachef = CacheMap(uri)
	if not cachef.exists() or cachef.isExpired():
		wt.download()
		wt.saveHtml(cachef.getCacheFilename())
	else:
		wt.load(cachef.getCacheFilename())

	# Convert & save result
	wt.convertWithXslt(tplFile)
	wt.saveRdf(rdfOut)


def main():
	if len(sys.argv) < 2:
		print "Must call with at least a URI parameter."
		print "Usage: %s uriSrc [, cacheHtmlSrc [, rdfOut [, htmlOut ] ] ]" % \
			sys.argv[0]
		return

	# Meh, ugly...
	args = sys.argv
	if len(args) == 2:
		transform(args[1])
	elif len(args) == 3:
		transform(args[1], args[2])
	elif len(args) == 4:
		transform(args[1], args[2], args[3])
	elif len(args) == 5:
		transform(args[1], args[2], args[3], args[4])


if __name__ == '__main__':
	main()
