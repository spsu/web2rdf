#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit
# http://possibilistic.org
# echelon@gmail.com
# This code available under the GPL 3 unless otherwise noted.

from WebTransform import WebTransform
import sys

def main():
	uri = "http://tech.slashdot.org/comments.pl?sid=1407483&cid=29772213"
	loadFile = "./cache/slashdot-story.html"
	tplFile = "./sites/slashdot/slashdot-users.xsl"
	outFile = "./cache.rdf"
	outFile2 = "./cache.html"
	if len(sys.argv) >= 3:
		uri = sys.argv[1]
		tplFile = sys.argv[2]
	if len(sys.argv) >= 4:
		outFile = sys.argv[3]

	wt = WebTransform(uri)
	#wt.download()
	wt.load(loadFile)
	wt.convertWithXslt(tplFile)
	wt.saveRdf(outFile)
	wt.saveHtml(outFile2)


if __name__ == '__main__':
	main()
