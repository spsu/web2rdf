#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit
# http://possibilistic.org
# echelon@gmail.com
# This code available under the GPL 3 unless otherwise noted.

from urlparse import urlparse
import httplib
import libxml2
import libxslt

# TODO: Allow import of (X)HTML strings as an alternative to downloading.

class WebTransform(object):
	"""
	Download an (X)HTML document over the web and transform it to RDF (usually)
	using XSL Transformation templates. 
	
	== Example Usage ==
		wt = WebTransform(url)
		wt.download()
		wt.convertWithXslt("./some/template.xsl")	# TODO: Rename convertFile()
		wt.saveRdf("./output1.rdf")					# TODO: Rename save()

		wt.resetXsl()
		wt.convertWithXslt("./some/other/template.xsl")
		wt.saveRdf("./output2.rdf")
	"""

	def __init__(self, uri, cacheUri = None):
		"""CTOR.
		URI represents the location of the document to download. If desired, an
		optional cacheUri may be supplied for download instead. In the this 
		case, the original uri provided still represents the original source.
		"""
		self.uri = uri
		self.cacheUri = cacheUri

		# Processed data
		self.html = None # type: String
		self.xslt = None # type: Libxslt
		self.rdf = None # type: Libxml

	def __del__(self):
		"""DTOR. Cleans up libxml objects, etc."""
		self.reset()

	def download(self):
		"""Download from the original source or from a cached/saved file hosted 
		on a local server."""
		uri = self.uri
		if self.cacheUri:
			uri = self.cacheUri

		u = urlparse(uri)
		path = u.path + ("?" + u.query if u.query else "") + u.fragment
		if not path:
			path = "/"

		print "Downloading %s from %s..." % (path, u.netloc)
		conn = httplib.HTTPConnection(u.netloc)
		conn.request("GET", path)
		print "Downloaded."

		resp = conn.getresponse()

		self.html = str(resp.read())

	def load(self, filename):
		"""Load HTML from a file instead of downloading."""
		f = open(filename)
		self.html = f.read()
		f.close()

	def convert(self):
		"""Convert to RDF with the XSL Template mapped to the URI."""
		# TODO: DOMAIN/PATH-REGEX URL TO TEMPLATE MAP!
		pass

	def convertWithXslt(self, xsltFile, saveFile=None):
		"""Convert to RDF with the specified XSL Template."""
		if not self.html:
			print "convertWithXslt() err: HTML not downloaded!"
			return
		htmldoc = self.__convertXhtml() # TODO: Free
		xdoc = libxml2.parseFile(xsltFile) # TODO: Free
		self.xslt = libxslt.parseStylesheetDoc(xdoc)
		self.rdf = self.xslt.applyStylesheet(htmldoc, None)

	def saveHtml(self, saveFile):
		"""Save processed XHTML data."""
		# TODO - save processed XHTML data instead of raw html.
		f = open(saveFile, 'w')
		f.write(self.html)
		f.close()

	def saveRdf(self, saveFile):
		"""Save returned RDF data."""
		if not self.xslt or not self.rdf:
			print "saveRdf() err: No RDF to save."
			return
		if not saveFile or type(saveFile) != str:
			print "saveRdf() err: Must specify a save file."
			return

		self.xslt.saveResultToFilename(saveFile, self.rdf, 0)
		
	def resetXsl(self):
		"""Remove cached XSLT and RDF, but keep the HTML."""
		if self.xslt:
			self.xslt.freeStylesheet()
			self.xslt = None
		self.rdf = None # TODO: Probably doesn't free

	def reset(self):
		"""Remove cached HTML, XSLT, and RDF. Only keep the original URI."""
		if self.xslt:
			self.xslt.freeStylesheet()
			self.xslt = None
		self.rdf = None # TODO: Probably doesn't free
		self.html = None
		

	def __convertXhtml(self):
		"""Convert HTML to XHTML"""
		hParser = libxml2.htmlCreateMemoryParserCtxt(self.html, len(self.html))
		hParser.htmlCtxtUseOptions(
				libxml2.HTML_PARSE_RECOVER |
				libxml2.HTML_PARSE_NOBLANKS |
				libxml2.HTML_PARSE_NOWARNING |
				libxml2.HTML_PARSE_NOERROR
		)
		ret = hParser.htmlParseDocument()
		if ret == -1:
			print "HTML was malformed, but processed to XHTML anyway."

		d = hParser.doc()
		if not d:
			print "Libxml error: could not convert to XHTML."
			return

		return d

