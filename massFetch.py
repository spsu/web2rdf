#!/usr/bin/env python2.6

import warnings
warnings.simplefilter("ignore",DeprecationWarning)

# Just testing now

import rdflib
from rdflib.Graph import ConjunctiveGraph as Graph
from rdflib import Namespace
from rdflib import Literal
from rdflib import URIRef

from rdflib import plugin
from rdflib.store import Store, NO_STORE, VALID_STORE
from rdflib.store import SQLite

from rdfstore.RdfStore import RdfStore
from web2rdf.Web2Rdf import Web2Rdf

import sys

# Return string IO
def rdfString(string):
	from cStringIO import StringIO
	return StringIO(string)

# Main function
def main():
	"""Uploads many RDF graphs into storage."""

	uris = [
		'http://tech.slashdot.org/story/09/11/02/0734253/Transpacific-Unity-Fiber-Optic-Cable-Leaves-Japan',
		'http://games.slashdot.org/story/09/10/29/2026217/Nintendo-Announces-DSi-XL',
		'http://games.slashdot.org/story/09/10/28/1634218/Leaked-Modern-Warfare-2-Footage-Causes-Outrage',
		'http://games.slashdot.org/story/09/11/01/1421253/Scams-and-Social-Gaming',
		'http://apple.slashdot.org/story/09/10/26/2256212/Psystars-Rebel-EFI-Hackintosh-Tool-Reviewed-Found-Wanting',
		'http://yro.slashdot.org/story/09/11/03/0331227/Feds-Bust-Cable-Modem-Hacker',
		'http://hardware.slashdot.org/story/09/11/02/2048234/Europe-Launches-Flood-Predicting-Satellite-and-Test-Probe',
		'http://yro.slashdot.org/story/09/11/02/1411252/An-Inbox-Is-Not-a-Glove-Compartment',
		'http://science.slashdot.org/story/09/11/03/1554207/2-Companies-Win-NASAs-Moon-Landing-Prize-Money',
		'http://news.slashdot.org/story/09/11/03/1751232/Rise-of-the-Robot-Squadrons',
		'http://it.slashdot.org/story/09/10/21/2120251/Some-Users-Say-Win7-Wants-To-Remove-iTunes-Google-Toolbar',
		'http://apple.slashdot.org/story/09/10/23/1456221/Apple-Seeks-Patent-On-Operating-System-Advertising',
		'http://games.slashdot.org/story/09/10/29/0225250/Physics-Rebel-Aims-To-Shake-Up-the-Video-Game-World',
		'http://games.slashdot.org/story/09/10/28/030237/2D-Boy-Posts-Pay-What-You-Want-Final-Wrap-up',
		'http://it.slashdot.org/story/09/11/02/1622218/IT-Snake-Oil-mdash-Six-Tech-Cure-Alls-That-Went-Bunk',
		'http://apple.slashdot.org/story/09/10/20/1833228/Apple-Blurs-the-Server-Line-With-Mac-Mini-Server',
		'http://games.slashdot.org/story/09/11/02/1530221/Free-3G-Wireless-For-Nintendos-Next-Handheld',
		'http://hardware.slashdot.org/story/09/11/03/1530258/Dell-Rugged-Laptops-Not-Quite-Tough-Enough',
		'http://linux.slashdot.org/story/09/11/03/2211231/Some-Early-Adopters-Stung-By-Ubuntus-Karmic-Koala',
		'http://hardware.slashdot.org/story/09/10/31/0120223/Contest-To-Hack-Brazilian-Voting-Machines',
		'http://ask.slashdot.org/story/09/10/25/1615203/Low-Power-Home-Linux-Server',
		'http://games.slashdot.org/story/09/10/30/0149253/FCC-Mulling-More-Control-For-Electronic-Media',
		'http://mobile.slashdot.org/story/09/11/03/1649246/Unfinished-Windows-7-Hotspot-Feature-Exploited',
		'http://games.slashdot.org/story/09/10/30/2040230/Nokias-N-Gage-Service-To-End-After-2010',
		'http://linux.slashdot.org/story/09/10/29/128205/Ubuntu-910-Officially-Released',
		'http://ask.slashdot.org/story/09/10/30/2126252/Installing-Linux-On-Old-Hardware',
		'http://games.slashdot.org/story/09/10/31/1428225/Controlling-Games-and-Apps-Through-Muscle-Sensors',
		'http://tech.slashdot.org/story/09/11/01/2131249/uTorrent-To-Build-In-Transfer-Throttling-Ability',
		'http://news.slashdot.org/story/09/11/02/2342258/Microsoft-Links-Malware-Rates-To-Pirated-Windows',
		'http://apple.slashdot.org/story/09/10/29/0311214/Speech-to-Speech-Translator-Developed-For-iPhone',
		'http://games.slashdot.org/story/09/10/30/022242/DampD-On-Google-Wave',
		'http://science.slashdot.org/story/09/11/02/1435227/Bacteria-Could-Survive-In-Martian-Soil',
		'http://apple.slashdot.org/story/09/11/02/0853219/For-September-Book-Related-Apps-Overtook-Games-On-iPhone',
		'http://hardware.slashdot.org/story/09/11/03/1427210/Negroponte-Hints-At-Paper-Like-Design-For-XO-3',
		'http://science.slashdot.org/story/09/11/03/0313242/Giant-Rift-In-Africa-Will-Create-a-New-Ocean',
		'http://yro.slashdot.org/story/09/11/02/132211/Attorney-General-Says-Wiretap-Lawsuit-Must-Be-Thrown-Out',
		'http://linux.slashdot.org/story/09/10/25/0450232/Ryan-Gordon-Wants-To-Bring-Universal-Binaries-To-Linux',
		'http://science.slashdot.org/story/09/11/01/2145208/Computer-Activities-for-Those-With-Speech-and-Language-Difficulties',
		'http://science.slashdot.org/story/09/11/03/1842247/The-Tech-Aboard-the-International-Space-Station',
		'http://science.slashdot.org/story/09/11/03/1450211/Scientists-Build-a-Smarter-Rat',
		'http://yro.slashdot.org/story/09/11/03/2023209/Spring-Design-Sues-Barnes-amp-Noble-Over-Nook-IP',
		'http://apple.slashdot.org/story/09/11/01/195232/Apple-Says-Booting-OS-X-Makes-an-Unauthorized-Copy',
		'http://yro.slashdot.org/story/09/10/22/1541220/Nokia-Sues-Apple-For-Patent-Infringement-In-iPhone',
		'http://linux.slashdot.org/story/09/10/23/1639234/Ubuntu-Karmic-Koala-RC-Hits-the-Streets-With-Windows-7',
		'http://linux.slashdot.org/story/09/10/27/1335227/Comparing-the-Freedoms-Offered-By-Maemo-and-Android'
	]

	i = 0
	for uri in uris:

		# Get the RDF
		wrdf = Web2Rdf(uri)
		rdf = wrdf.getRdf()

		if not rdf:
			print "No RDF returned!"
			return False

		print "Got RDF..."
		rdf = rdfString(rdf)

		# Open Storage
		print "Opening store..."
		#params = "./newdatabase.sqlite" 					# SQLITE
		params = ('localhost', 'tuser', 'tuser', 'rdf') 	# MYSQL
		rstore = RdfStore(params)
		rstore.open()

		print "Storing..."
		graph = Graph(rstore.get(), identifier = URIRef("http://slashdot/"))
		#graph.parse("example.rdf")
		graph.parse(rdf, publicID=uri)

		graph.commit()
		i+=1
		print "%d of %d uris complete." % (i, len(uris))

if __name__ == '__main__': main()



