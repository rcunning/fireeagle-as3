# Fire Eagle ActionScript 3 client library

fireeagle-as3 is a set of classes for accessing the 
[Fire Eagle](http://fireeagle.yahoo.net/ "Fire Eagle") REST API
and XMPP [PubSub](http://xmpp.org/extensions/xep-0060.html "XEP-0060: Publish-Subscribe") feed.

## Getting started

Download a copy of fireeagle-as3:

    [fireeagle-as3](http://github.com/rcunning/fireeagle-as3/tree/master# "fireeagle-as3")

Or clone fireeagle-as3 source from github:

    $ git clone git://github.com/rcunning/fireeagle-as3.git

Download the other required sources:

    [Yahoo! Y!OS AS3 library](http://developer.yahoo.com/flash/yos/ "Y!OS AS3 library")
    [twhix XMPP library](http://code.google.com/p/twhix/ "twhix XMPP library") - _If you want XMPP support_

Setup:

    Download all source from above to <your extract path>
      will create 
        <your extract path>/fireeagle-as3
        <your extract path>/yos_as3_sdk-1.1.1
        <your extract path>/twhix-read-only _if you want XMPP support_
    Create a Flex Builder of Flash project of your choosing
    Include source from <your extract path>/fireeagle-as3/src in your project
    Include source from <your extract path>/yos_as3_sdk-1.1.1/Source
    Include swc from <your extract path>/twhix-read-only/twhix/bin/twhix.swc
    See fireeagle-as3 docs in <your extract path>/fireeagle-as3/Docs

## REST API Usage

    FireEagleMethod -- call any of the standard Fire Eagle REST API methods
    FireEagleAuth -- util class for authorizing new access tokens

## XMPP Usage

    realtime/XMPPConnection -- connect to an XMPP server, receive userSuccess events on subscribed user location updates
    Use [Switchboard](http://github.com/mojodna/switchboard "Switchboard") to subscribe user pubsub nodes

## Sample Flex application that exercises all features of fireeagle-as3

    [Fire Eagle AS3 Tester](http://github.com/rcunning/fireeagleas3tester/ "fireeagleas3tester")

## Getting Help

Your best bet for help is to post a message to the Fire Eagle Yahoo! Group:
[http://tech.groups.yahoo.com/group/fireeagle/](http://tech.groups.yahoo.com/group/fireeagle/ "Fire Eagle Yahoo! Group")

## Notes

JSON parse classes taken from as3corelib: [http://code.google.com/p/as3corelib/](http://code.google.com/p/as3corelib/ "as3corelib")

