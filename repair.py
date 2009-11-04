#!/usr/bin/env python2.6

import warnings
warnings.simplefilter("ignore",DeprecationWarning)

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

db = "./testdb.sqlite"
rstore = RdfStore('sqlite', db)
rstore.open()
store = rstore.get()

print "Doing garbage collection..."
store.gc()
store.commit()

