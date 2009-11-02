#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit
# http://possibilistic.org
# echelon@gmail.com

from lib.WebTransform import WebTransform
from lib.getTemplate import getTemplate
from lib.fixUri import fixUri
from lib.CacheMap import CacheMap

import sys # for main()
from os.path import exists # for module temp fix

# TODO [1] Librdf MEMLEAKS (XXX CRITICAL)
# TODO [2] Error recovery. 
# TODO [3] Blocking timeouts / cancelling blocking (need to make thread safe)
#		   This will likely be a multiprocess architecture broken into several
#		   "jobs" that are run by different daemons, crons, etc.
# TODO [4] Debugging of HTTP connections, etc.

"""
	Web2Rdf main interface API.

	Simple method to download and obtain RDF. Can be used for testing or 
	integration into other components of an RDF system. 

	Usage:

		wrdf = Web2Rdf('http://slashdot.org')
		wrdf.saveRdf('optionalFilename')
			OR
		rdf = wrdf.getRdf()

"""

class Web2Rdf(object):
	"""Web2Rdf controller class"""

	def __init__(self, uri):
		"""CTOR."""
		self.uri = uri
		self.webTransform = None

	def saveRdf(self, filename = None):
		"""Saves the RDF to a file"""
		if not self.webTransform:
			self.__doTransform()

		if not self.webTransform:
			return False

		if not filename:
			cachef = CacheMap(self.uri)
			filename = cachef.getCacheFilename() + ".cache.rdf"

		print "Saving to %s. " % filename
		self.webTransform.saveRdf(filename)

	def getRdf(self):
		"""Returns the RDF string."""
		if not self.webTransform:
			self.__doTransform()

		if not self.webTransform:
			return False

		# Get the RDF string.
		return str(self.webTransform.rdf)
		
	def __doTransform(self):
		"""Do the work."""

		uri = fixUri(self.uri)

		# Get template
		tplFile = getTemplate(self.uri)
		if not tplFile:
			print "Could not find matching template file for the URI."
			print "Uri was %s" % self.uri
			return False

		# TODO: Temp fix
		trypath = "./" + tplFile
		if exists(trypath):
			tplFile = trypath
		else:
			tplFile = "./web2rdf/" + tplFile

		self.webTransform = WebTransform(self.uri)

		# Web Cache logic
		cachef = CacheMap(self.uri)
		if not cachef.exists() or cachef.isExpired():
			self.webTransform.download()
			self.webTransform.saveHtml(cachef.getCacheFilename())
		else:
			self.webTransform.load(cachef.getCacheFilename())
		
		# Convert & save result
		self.webTransform.convertWithXslt(tplFile)

def main():
	"""Main Function
	Simple command-line procedure for web2rdf."""

	if len(sys.argv) < 2 or len(sys.argv) > 3:
		print "Must call with at least a URI parameter, optionally a save file."
		print "Usage: %s uriSrc [, rdfSaveFile ]" % \
			sys.argv[0]
		return

	uri = None
	savefile = None
	if len(sys.argv) >= 2:
		uri = sys.argv[1]
	if len(sys.argv) == 3:
		savefile = sys.argv[2]

	# Do the work
	wrdf = Web2Rdf(uri)
	wrdf.saveRdf(savefile)

if __name__ == '__main__': main()

