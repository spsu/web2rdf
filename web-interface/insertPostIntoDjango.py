#!/usr/bin/env python2.6

import sys
import os
sys.path.append(os.path.abspath('../../'))

import warnings
warnings.simplefilter("ignore", DeprecationWarning)

import rdflib
from rdflib.Graph import ConjunctiveGraph as Graph
from rdflib import Namespace
from rdflib import Literal
from rdflib import URIRef

from rdflib import plugin
from rdflib.store import Store, NO_STORE, VALID_STORE
from rdflib.store import SQLite
from rdflib.sparql.bison import Parse

from rdfstore.RdfStore import RdfStore

params = ('localhost', 'tuser', 'tuser', 'rdf')			# MYSQL
rstore = RdfStore(params)
rstore.open()
store = rstore.get()

print "===== Context ====="
ctx = None
for c in store.contexts():
	ctx = c
print ctx
print ""

graph = ctx

def getPosts(graph):
	query = """
			PREFIX sioc: <http://rdfs.org/sioc/ns#>
			PREFIX dcterms: <http://purl.org/dc/terms/>
			PREFIX sylph: <http://possibilistic.org/onto/>
			SELECT ?title ?content
			WHERE {
				?post a sioc:Post ;
					  dcterms:title ?title ;
					  sioc:content ?content .
			}
			"""
	query = Parse(query)

	posts = []
	for row in graph.query(query):
		posts.append((row[0], row[1]))

	return posts

posts = getPosts(graph)

##################

from news.models import Post

print Post.objects.all() 

for post in posts:
	p = Post(title=post[0], content=post[1])
	p.save()

print Post.objects.all()


