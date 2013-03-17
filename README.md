Redis-Tree
==========

LUA scripts which provide a tree index for Redis.

Have you ever wonder how to model categories tree view of your pop&mom's shop in the backend?
Or how to model multi-threaded conversations on your forum?

Certainly there are many possible ways to do that using SQL, Redis or MongoDB.
Hell, you could even try XML + XPath.
Or LDAP. Or FTP. No, I am not serious.

The day I've heard that Redis will add LUA support, I knew, that I have to create this project: 
a few simple LUA scripts which offer you a simple tree data structure.

Model
-----

     a : [0,1]
     a/ble : [2]
     a/ble/c/d/e : [7]
     c : [3]

This is supposed to be an index, not a data storage.
Therefore you can not store arbitrary data in your tree, unless your arbitrary data happen to be integers.
That's right, the data structure allows you to store any integer(s) in any node of the tree,
and the edges are labeled with arbitrary strings.
Labels should be locally unique (no two siblings should have the same label).
As this is a general purpose, one way index, a single integer can be placed in many different nodes -- I do not care.
But only at most a single copy of each integer will be stored in a node.
That's right, nodes are Redis's SETs of integers, that's why you can not have multiple copies of integers.
Nodes children are stored in a Redis's HASH, that's why you can not have multiple children with same label.
Internally nodes also have (unique) numbers but this is an implementation detail not exposed anyhow.

Misc
----

If you for some reason need to know what path leads to a node which stores integer "7", 
then just build your own a hash map for that purpose.

If you for some reason need to store a lot of data in a node, then just store it somewhere else
(preferably in key-value data store) and store just the key in my index.

If you do not like my LUA code style, be aware that I have no LUA code style.
This is my first day of writing in LUA.

