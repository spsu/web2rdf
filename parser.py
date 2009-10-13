#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit

import tidy
from elementtidy import TidyHTMLTreeBuilder

import httplib
import libxml2
import libxslt
import sys

def fetch(host, path):
	conn = httplib.HTTPConnection(host)
	conn.request("GET", path)
	r = conn.getresponse()
	data = r.read()

	d = str(data)


	f = open("./original.html","w")
	f.write(str(d))

	# Cleanup
	#options = dict(output_xhtml=1, add_xml_decl=1, indent=1, tidy_mark=0)
	#return tidy.parseString(data, options)
	d = str(data)
	hParser = libxml2.htmlCreateMemoryParserCtxt(d, len(d))
	hParser.htmlCtxtUseOptions(
			libxml2.HTML_PARSE_RECOVER |
			libxml2.HTML_PARSE_NOBLANKS |
			libxml2.HTML_PARSE_NOWARNING |
			libxml2.HTML_PARSE_NOERROR
	)

	ret = hParser.htmlParseDocument()
	if ret == -1:
		print "Html was malformed, but processed anyway."

	doc = hParser.doc()
	return doc

def xslParse(xmlIn, xslFile, saveFile = None):

	xmldoc = libxml2.parseFile(xslFile)
	xslt = libxslt.parseStylesheetDoc(xmldoc)
	#doc = libxml2.parseMemory(xmlStr, len(xmlStr))
	doc = xmlIn
	result = xslt.applyStylesheet(doc, None)
	if saveFile and type(saveFile) == str:
		xslt.saveResultToFilename(saveFile, result, 0)
	#xslt.freeStylesheet()
	#doc.freeDoc()
	#result.freeDoc()
	#xmldoc.freeDoc()


host = "slashdot.org"
path = "/"

doc = fetch(host, path)

f = open("./test.html","w")
f.write(str(doc))

#sys.exit()

xslParse(doc, "./sites/slashdot/slashdot-index.xsl", "./out.rdf")

