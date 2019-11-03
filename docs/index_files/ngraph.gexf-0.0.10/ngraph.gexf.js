(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
load_gexf = require('ngraph.gexf')

},{"ngraph.gexf":3}],2:[function(require,module,exports){
module.exports = function(subject) {
  validateSubject(subject);

  var eventsStorage = createEventsStorage(subject);
  subject.on = eventsStorage.on;
  subject.off = eventsStorage.off;
  subject.fire = eventsStorage.fire;
  return subject;
};

function createEventsStorage(subject) {
  // Store all event listeners to this hash. Key is event name, value is array
  // of callback records.
  //
  // A callback record consists of callback function and its optional context:
  // { 'eventName' => [{callback: function, ctx: object}] }
  var registeredEvents = Object.create(null);

  return {
    on: function (eventName, callback, ctx) {
      if (typeof callback !== 'function') {
        throw new Error('callback is expected to be a function');
      }
      var handlers = registeredEvents[eventName];
      if (!handlers) {
        handlers = registeredEvents[eventName] = [];
      }
      handlers.push({callback: callback, ctx: ctx});

      return subject;
    },

    off: function (eventName, callback) {
      var wantToRemoveAll = (typeof eventName === 'undefined');
      if (wantToRemoveAll) {
        // Killing old events storage should be enough in this case:
        registeredEvents = Object.create(null);
        return subject;
      }

      if (registeredEvents[eventName]) {
        var deleteAllCallbacksForEvent = (typeof callback !== 'function');
        if (deleteAllCallbacksForEvent) {
          delete registeredEvents[eventName];
        } else {
          var callbacks = registeredEvents[eventName];
          for (var i = 0; i < callbacks.length; ++i) {
            if (callbacks[i].callback === callback) {
              callbacks.splice(i, 1);
            }
          }
        }
      }

      return subject;
    },

    fire: function (eventName) {
      var callbacks = registeredEvents[eventName];
      if (!callbacks) {
        return subject;
      }

      var fireArguments;
      if (arguments.length > 1) {
        fireArguments = Array.prototype.splice.call(arguments, 1);
      }
      for(var i = 0; i < callbacks.length; ++i) {
        var callbackInfo = callbacks[i];
        callbackInfo.callback.apply(callbackInfo.ctx, fireArguments);
      }

      return subject;
    }
  };
}

function validateSubject(subject) {
  if (!subject) {
    throw new Error('Eventify cannot use falsy object as events subject');
  }
  var reservedWords = ['on', 'fire', 'off'];
  for (var i = 0; i < reservedWords.length; ++i) {
    if (subject.hasOwnProperty(reservedWords[i])) {
      throw new Error("Subject cannot be eventified, since it already has property '" + reservedWords[i] + "'");
    }
  }
}

},{}],3:[function(require,module,exports){
module.exports.save = require('./lib/save');
module.exports.load = require('./lib/load');


},{"./lib/load":8,"./lib/save":9}],4:[function(require,module,exports){
module.exports = function extractNamespaces(node) {
  var result = {};
  for (var i = 0; i < node.attributes.length; ++i) {
    var attr = node.attributes[i];
    if (attr.name.match(/^xmlns/)) {
      var parts = attr.name.split(':');
      var prefx = parts.length === 1 ? 'x' : parts[1];
      result[prefx] = attr.value;
    }
  }
  return result;
};

},{}],5:[function(require,module,exports){
module.exports = function (xml) {
  var doc = new ActiveXObject('Microsoft.XMLDOM');
  doc.setProperty("SelectionLanguage", "XPath");
  doc.loadXML(xml);
  var nameSpaces = require('./extracNamespaces')(doc.documentElement);

  var ns = Object.keys(nameSpaces).map(function (x) { return 'xmlns:' + x + "='" + nameSpaces[x] + "'"; }).join(' ');
  doc.setProperty("SelectionNamespaces", ns);

  return {
    selectNodes : function (name, startFrom, nsPrefix) {
      nsPrefix = nsPrefix || 'x';
      if (!nameSpaces[nsPrefix]) { return []; }

      var ctx = startFrom || doc;
      var selectNodeResult = ctx.selectNodes('.//' + nsPrefix + ':' + name);
      var result = [];
      for (var i = 0; i < selectNodeResult.length; ++i) {
        result.push(selectNodeResult[i]);
      }
      return result;
    },

    getText: function (node) {
      return node && node.text;
    }
  };
};

},{"./extracNamespaces":4}],6:[function(require,module,exports){
module.exports = function (xml) {
  var parser = new DOMParser();
  doc = parser.parseFromString(xml, 'text/xml');
  var n = extractNamespaces(doc.documentElement);
  var nameSpaces = require('./extracNamespaces')(doc.documentElement);

  return {
    selectNodes : function (name, startFrom, nsPrefix) {
      nsPrefix = nsPrefix || 'x';
      if (!nameSpaces[nsPrefix]) { return []; }

      var root = startFrom || doc;
      var xpathResult = doc.evaluate(".//" + nsPrefix + ":" + name, root, nsResolver, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
      var result = [];

      for(var i = 0; i < xpathResult.snapshotLength; i++) {
        result.push(xpathResult.snapshotItem(i));
      }

      return result;
    },

    getText: function (node) {
      return node && node.textContent;
    }
  };

  function nsResolver(prefix) {
    return nameSpaces[prefix] || null;
  }

  function extractNamespaces(node) {
    var result = [];
    for (var i = 0; i < node.attributes.length; ++i) {
      var attr = node.attributes[i];
      if (attr.name.match(/^xmlns/)) {
        var parts = attr.name.split(':');
        var prefx = parts.length === 1 ? 'x' : parts[1];
        result.push({ prefix: prefx, href: attr.value });
      }
    }
    return result;
  }
};

},{"./extracNamespaces":4}],7:[function(require,module,exports){
/**
 * This module provide API to parse gexf XMl file in the browser. When in node.js
 * this file is not used (see ../xmlParser.js instead);
 */
module.exports = function (xml) {
  if (typeof document.evaluate === 'function') {
    return require('./nonie.js')(xml);
  }
  else {
    return require('./ie.js')(xml);
  }
}

},{"./ie.js":5,"./nonie.js":6}],8:[function(require,module,exports){
module.exports = load;

function load(gexfContent) {
  var graph = require('ngraph.graph')();
  var attributesDef = {},
      defaultAttrValues = {};

  var parser = require('./xmlParser')(gexfContent);

  parser.selectNodes('attribute').forEach(addAttributeDef);
  parser.selectNodes('node').forEach(addNode);
  parser.selectNodes('edge').forEach(addLink);

  var links = parser;
  return graph;

  function addAttributeDef(node) {
    var attr = copyAttributes(node);
    attributesDef[attr.id] = {
      title: attr.title,
      type: attr.type
    };

    parser.selectNodes('default', node).forEach(function (node) {
      var def = attributesDef[attr.id];
      addDefaultAttrValue(node, def.title, def.type);
    });
  }

  function addNode(node) {
    var nodeData = copyAttributes(node);
    var id = nodeData.id;
    delete nodeData.id;

    addNodeData(nodeData, node);
    addNodeViz(nodeData, node);
    graph.addNode(id, nodeData);
  }

  function addLink(node) {
    var attributes = copyAttributes(node);
    var link = graph.addLink(attributes.source, attributes.target);
    link.id = attributes.id;
    if (attributes.weight !== undefined) {
      link.weight = extractNumberIfCan(attributes.weight);
    }
  }

  function addNodeData(target, xmlNode) {
    // first we parse defined attributes on node:
    parser.selectNodes('attvalue', xmlNode)
          .forEach(function (node) {
            var attr = copyAttributes(node);
            var def = attributesDef[attr.for || attr.id];
            target[def.title] = parseType(attr.value, def.type);
          });
    // second we make sure we didn't miss default values:
    for (var key in defaultAttrValues) {
      if (defaultAttrValues.hasOwnProperty(key) &&
         !target.hasOwnProperty(key)) {
        target[key] = defaultAttrValues[key];
      }
    }
  }

  function addNodeViz(target, xmlNode) {
    var vizNodes = parser.selectNodes('*', xmlNode, 'viz');
    if (vizNodes.length === 0) {
      return;
    }
    var viz = {};
    for (var i = 0; i < vizNodes.length; ++i) {
      var vizElement = vizNodes[i];
      var attributes = flatten(copyAttributes(vizElement, extractNumberIfCan));
      viz[vizElement.baseName || vizElement.localName || vizElement.nodeName] = attributes;
    }
    target.viz = viz;
  }

  function parseType(value, type) {
    switch (type) {
      case "integer":
      case "long":
      case "double":
      case "float":
        return parseFloat(value);
      case "boolean":
        return value === 'true';
    }
    return value;
  }

  function addDefaultAttrValue(node, id, type) {
    var text = parser.getText(node);
    if (text) {
      defaultAttrValues[id] = parseType(text, type);
    }
  }
}

function copyAttributes(node, transform) {
  var attributes = {};
  transform = transform || id;
  for (var i = 0; i < node.attributes.length; ++i) {
    var name = node.attributes[i].nodeName;
    attributes[name] = transform(node.attributes[i].nodeValue);
  }

  return attributes;
}

function id(value) {
  return value;
}

function extractNumberIfCan(value) {
  var num = parseFloat(value);
  return isNaN(num) ? value : num;
}

function flatten(obj) {
  if (obj && obj.value) {
    return extractNumberIfCan(obj.value);
  }
  return obj;
}

function buildGraph(graph, doc) {
  var $ = select(doc);
  var nodes = $('gexf > graph > nodes > node');
}

},{"./xmlParser":7,"ngraph.graph":10}],9:[function(require,module,exports){
module.exports = save;

function save(graph) {
  var nodes = [];
  var links = [];
  var attributes = [];
  var uniqueAttributes = {};
  var attrIdx = 0;

  graph.forEachNode(function (node) {
    var label = (node.data && node.data.label) || '';
    if (label) {
      label = ' label="' + label + '"';
    }

    nodes.push('<node id="' + node.id + '"' + label + '>');

    if (node.data) {
      var keys = Object.keys(node.data).filter(function (attr) {
        return attr !== 'label' && supportedType(node.data[attr]);
      });
      if (keys.length > 0)  {
        nodes.push('<attvalues>');
        keys.forEach(function (key) {
          if (!uniqueAttributes.hasOwnProperty(key)) {
            attributes.push('<attribute id="' + attrIdx + '" title="' + key + '" type="' + getType(node.data[key]) + '"/>');
            uniqueAttributes[key] = attrIdx++;
          }

          // todo: this will need encoding for complex data:
          nodes.push('<attvalue for="' + uniqueAttributes[key] + '" value="' + node.data[key] + '"/>');
        });
        nodes.push('</attvalues>');
      }
    }

    nodes.push('</node>');
  });

  var linkId = 0;
  graph.forEachLink(function (link) {
    linkId += 1;
    var linkDef = '<edge id="' + linkId + '" source="' + link.fromId + '" target="' + link.toId + '"';
    if (typeof link.weight === 'number') {
      linkDef += ' weight="' + link.weight + '"';
    }

    links.push(linkDef + '/>');
  });

  var header = writeHeader();
  var attributesDef = '';
  var nodesStr = '';
  if (nodes.length > 0) {
    attributesDef = '<attributes class="node">' + attributes.join('') + '</attributes>';
    nodesStr = '<nodes>' + nodes.join('') + '</nodes>';
  }
  var edgesStr = '';
  if (links.length > 0) {
    edgesStr = '<edges>' + links.join('') + '</edges>';
  }

  return [header,
    '<graph>',
      attributesDef,
      nodesStr,
      edgesStr,
    '</graph>',
    '</gexf>'
  ].join('\n');
}

function writeHeader(){
  return [
'<?xml version="1.0" encoding="UTF-8"?>',
'<gexf xmlns="http://www.gexf.net/1.2draft" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd" version="1.2">',
'    <meta lastmodifieddate="' + (new Date()).toISOString().split('T')[0] + '">',
'       <creator>http://github.com/anvaka/ngraph</creator>',
'       <description>Beautiful graphs</description>',
'   </meta>'
  ].join('\n');
}

function getType(obj) {
  switch (typeof (obj)) {
    case "number" : return 'float';
    case "boolean": return 'boolean';
    default: return 'string';
  }
}

function supportedType(obj) {
  var t = typeof (obj);
  return  t === 'number' || t === 'boolean' || t === 'string';
}

},{}],10:[function(require,module,exports){
/**
 * @fileOverview Contains definition of the core graph object.
 */

/**
 * @example
 *  var graph = require('ngraph.graph')();
 *  graph.addNode(1);     // graph has one node.
 *  graph.addLink(2, 3);  // now graph contains three nodes and one link.
 *
 */
module.exports = createGraph;

var eventify = require('ngraph.events');

/**
 * Creates a new graph
 */
function createGraph(options) {
  // Graph structure is maintained as dictionary of nodes
  // and array of links. Each node has 'links' property which
  // hold all links related to that node. And general links
  // array is used to speed up all links enumeration. This is inefficient
  // in terms of memory, but simplifies coding.
  options = options || {};
  if (options.uniqueLinkId === undefined) {
    // Request each link id to be unique between same nodes. This negatively
    // impacts `addLink()` performance (O(n), where n - number of edges of each
    // vertex), but makes operations with multigraphs more accessible.
    options.uniqueLinkId = true;
  }

  var nodes = typeof Object.create === 'function' ? Object.create(null) : {},
    links = [],
    // Hash of multi-edges. Used to track ids of edges between same nodes
    multiEdges = {},
    nodesCount = 0,
    suspendEvents = 0,

    forEachNode = createNodeIterator(),
    createLink = options.uniqueLinkId ? createUniqueLink : createSingleLink,

    // Our graph API provides means to listen to graph changes. Users can subscribe
    // to be notified about changes in the graph by using `on` method. However
    // in some cases they don't use it. To avoid unnecessary memory consumption
    // we will not record graph changes until we have at least one subscriber.
    // Code below supports this optimization.
    //
    // Accumulates all changes made during graph updates.
    // Each change element contains:
    //  changeType - one of the strings: 'add', 'remove' or 'update';
    //  node - if change is related to node this property is set to changed graph's node;
    //  link - if change is related to link this property is set to changed graph's link;
    changes = [],
    recordLinkChange = noop,
    recordNodeChange = noop,
    enterModification = noop,
    exitModification = noop;

  // this is our public API:
  var graphPart = {
    /**
     * Adds node to the graph. If node with given id already exists in the graph
     * its data is extended with whatever comes in 'data' argument.
     *
     * @param nodeId the node's identifier. A string or number is preferred.
     * @param [data] additional data for the node being added. If node already
     *   exists its data object is augmented with the new one.
     *
     * @return {node} The newly added node or node with given id if it already exists.
     */
    addNode: addNode,

    /**
     * Adds a link to the graph. The function always create a new
     * link between two nodes. If one of the nodes does not exists
     * a new node is created.
     *
     * @param fromId link start node id;
     * @param toId link end node id;
     * @param [data] additional data to be set on the new link;
     *
     * @return {link} The newly created link
     */
    addLink: addLink,

    /**
     * Removes link from the graph. If link does not exist does nothing.
     *
     * @param link - object returned by addLink() or getLinks() methods.
     *
     * @returns true if link was removed; false otherwise.
     */
    removeLink: removeLink,

    /**
     * Removes node with given id from the graph. If node does not exist in the graph
     * does nothing.
     *
     * @param nodeId node's identifier passed to addNode() function.
     *
     * @returns true if node was removed; false otherwise.
     */
    removeNode: removeNode,

    /**
     * Gets node with given identifier. If node does not exist undefined value is returned.
     *
     * @param nodeId requested node identifier;
     *
     * @return {node} in with requested identifier or undefined if no such node exists.
     */
    getNode: getNode,

    /**
     * Gets number of nodes in this graph.
     *
     * @return number of nodes in the graph.
     */
    getNodesCount: function() {
      return nodesCount;
    },

    /**
     * Gets total number of links in the graph.
     */
    getLinksCount: function() {
      return links.length;
    },

    /**
     * Gets all links (inbound and outbound) from the node with given id.
     * If node with given id is not found null is returned.
     *
     * @param nodeId requested node identifier.
     *
     * @return Array of links from and to requested node if such node exists;
     *   otherwise null is returned.
     */
    getLinks: getLinks,

    /**
     * Invokes callback on each node of the graph.
     *
     * @param {Function(node)} callback Function to be invoked. The function
     *   is passed one argument: visited node.
     */
    forEachNode: forEachNode,

    /**
     * Invokes callback on every linked (adjacent) node to the given one.
     *
     * @param nodeId Identifier of the requested node.
     * @param {Function(node, link)} callback Function to be called on all linked nodes.
     *   The function is passed two parameters: adjacent node and link object itself.
     * @param oriented if true graph treated as oriented.
     */
    forEachLinkedNode: forEachLinkedNode,

    /**
     * Enumerates all links in the graph
     *
     * @param {Function(link)} callback Function to be called on all links in the graph.
     *   The function is passed one parameter: graph's link object.
     *
     * Link object contains at least the following fields:
     *  fromId - node id where link starts;
     *  toId - node id where link ends,
     *  data - additional data passed to graph.addLink() method.
     */
    forEachLink: forEachLink,

    /**
     * Suspend all notifications about graph changes until
     * endUpdate is called.
     */
    beginUpdate: enterModification,

    /**
     * Resumes all notifications about graph changes and fires
     * graph 'changed' event in case there are any pending changes.
     */
    endUpdate: exitModification,

    /**
     * Removes all nodes and links from the graph.
     */
    clear: clear,

    /**
     * Detects whether there is a link between two nodes.
     * Operation complexity is O(n) where n - number of links of a node.
     * NOTE: this function is synonim for getLink()
     *
     * @returns link if there is one. null otherwise.
     */
    hasLink: getLink,

    /**
     * Gets an edge between two nodes.
     * Operation complexity is O(n) where n - number of links of a node.
     *
     * @param {string} fromId link start identifier
     * @param {string} toId link end identifier
     *
     * @returns link if there is one. null otherwise.
     */
    getLink: getLink
  };

  // this will add `on()` and `fire()` methods.
  eventify(graphPart);

  monitorSubscribers();

  return graphPart;

  function monitorSubscribers() {
    var realOn = graphPart.on;

    // replace real `on` with our temporary on, which will trigger change
    // modification monitoring:
    graphPart.on = on;

    function on() {
      // now it's time to start tracking stuff:
      graphPart.beginUpdate = enterModification = enterModificationReal;
      graphPart.endUpdate = exitModification = exitModificationReal;
      recordLinkChange = recordLinkChangeReal;
      recordNodeChange = recordNodeChangeReal;

      // this will replace current `on` method with real pub/sub from `eventify`.
      graphPart.on = realOn;
      // delegate to real `on` handler:
      return realOn.apply(graphPart, arguments);
    }
  }

  function recordLinkChangeReal(link, changeType) {
    changes.push({
      link: link,
      changeType: changeType
    });
  }

  function recordNodeChangeReal(node, changeType) {
    changes.push({
      node: node,
      changeType: changeType
    });
  }

  function addNode(nodeId, data) {
    if (nodeId === undefined) {
      throw new Error('Invalid node identifier');
    }

    enterModification();

    var node = getNode(nodeId);
    if (!node) {
      node = new Node(nodeId);
      nodesCount++;
      recordNodeChange(node, 'add');
    } else {
      recordNodeChange(node, 'update');
    }

    node.data = data;

    nodes[nodeId] = node;

    exitModification();
    return node;
  }

  function getNode(nodeId) {
    return nodes[nodeId];
  }

  function removeNode(nodeId) {
    var node = getNode(nodeId);
    if (!node) {
      return false;
    }

    enterModification();

    if (node.links) {
      while (node.links.length) {
        var link = node.links[0];
        removeLink(link);
      }
    }

    delete nodes[nodeId];
    nodesCount--;

    recordNodeChange(node, 'remove');

    exitModification();

    return true;
  }


  function addLink(fromId, toId, data) {
    enterModification();

    var fromNode = getNode(fromId) || addNode(fromId);
    var toNode = getNode(toId) || addNode(toId);

    var link = createLink(fromId, toId, data);

    links.push(link);

    // TODO: this is not cool. On large graphs potentially would consume more memory.
    addLinkToNode(fromNode, link);
    if (fromId !== toId) {
      // make sure we are not duplicating links for self-loops
      addLinkToNode(toNode, link);
    }

    recordLinkChange(link, 'add');

    exitModification();

    return link;
  }

  function createSingleLink(fromId, toId, data) {
    var linkId = makeLinkId(fromId, toId);
    return new Link(fromId, toId, data, linkId);
  }

  function createUniqueLink(fromId, toId, data) {
    // TODO: Get rid of this method.
    var linkId = makeLinkId(fromId, toId);
    var isMultiEdge = multiEdges.hasOwnProperty(linkId);
    if (isMultiEdge || getLink(fromId, toId)) {
      if (!isMultiEdge) {
        multiEdges[linkId] = 0;
      }
      var suffix = '@' + (++multiEdges[linkId]);
      linkId = makeLinkId(fromId + suffix, toId + suffix);
    }

    return new Link(fromId, toId, data, linkId);
  }

  function getLinks(nodeId) {
    var node = getNode(nodeId);
    return node ? node.links : null;
  }

  function removeLink(link) {
    if (!link) {
      return false;
    }
    var idx = indexOfElementInArray(link, links);
    if (idx < 0) {
      return false;
    }

    enterModification();

    links.splice(idx, 1);

    var fromNode = getNode(link.fromId);
    var toNode = getNode(link.toId);

    if (fromNode) {
      idx = indexOfElementInArray(link, fromNode.links);
      if (idx >= 0) {
        fromNode.links.splice(idx, 1);
      }
    }

    if (toNode) {
      idx = indexOfElementInArray(link, toNode.links);
      if (idx >= 0) {
        toNode.links.splice(idx, 1);
      }
    }

    recordLinkChange(link, 'remove');

    exitModification();

    return true;
  }

  function getLink(fromNodeId, toNodeId) {
    // TODO: Use sorted links to speed this up
    var node = getNode(fromNodeId),
      i;
    if (!node || !node.links) {
      return null;
    }

    for (i = 0; i < node.links.length; ++i) {
      var link = node.links[i];
      if (link.fromId === fromNodeId && link.toId === toNodeId) {
        return link;
      }
    }

    return null; // no link.
  }

  function clear() {
    enterModification();
    forEachNode(function(node) {
      removeNode(node.id);
    });
    exitModification();
  }

  function forEachLink(callback) {
    var i, length;
    if (typeof callback === 'function') {
      for (i = 0, length = links.length; i < length; ++i) {
        callback(links[i]);
      }
    }
  }

  function forEachLinkedNode(nodeId, callback, oriented) {
    var node = getNode(nodeId);

    if (node && node.links && typeof callback === 'function') {
      if (oriented) {
        return forEachOrientedLink(node.links, nodeId, callback);
      } else {
        return forEachNonOrientedLink(node.links, nodeId, callback);
      }
    }
  }

  function forEachNonOrientedLink(links, nodeId, callback) {
    var quitFast;
    for (var i = 0; i < links.length; ++i) {
      var link = links[i];
      var linkedNodeId = link.fromId === nodeId ? link.toId : link.fromId;

      quitFast = callback(nodes[linkedNodeId], link);
      if (quitFast) {
        return true; // Client does not need more iterations. Break now.
      }
    }
  }

  function forEachOrientedLink(links, nodeId, callback) {
    var quitFast;
    for (var i = 0; i < links.length; ++i) {
      var link = links[i];
      if (link.fromId === nodeId) {
        quitFast = callback(nodes[link.toId], link);
        if (quitFast) {
          return true; // Client does not need more iterations. Break now.
        }
      }
    }
  }

  // we will not fire anything until users of this library explicitly call `on()`
  // method.
  function noop() {}

  // Enter, Exit modification allows bulk graph updates without firing events.
  function enterModificationReal() {
    suspendEvents += 1;
  }

  function exitModificationReal() {
    suspendEvents -= 1;
    if (suspendEvents === 0 && changes.length > 0) {
      graphPart.fire('changed', changes);
      changes.length = 0;
    }
  }

  function createNodeIterator() {
    // Object.keys iterator is 1.3x faster than `for in` loop.
    // See `https://github.com/anvaka/ngraph.graph/tree/bench-for-in-vs-obj-keys`
    // branch for perf test
    return Object.keys ? objectKeysIterator : forInIterator;
  }

  function objectKeysIterator(callback) {
    if (typeof callback !== 'function') {
      return;
    }

    var keys = Object.keys(nodes);
    for (var i = 0; i < keys.length; ++i) {
      if (callback(nodes[keys[i]])) {
        return true; // client doesn't want to proceed. Return.
      }
    }
  }

  function forInIterator(callback) {
    if (typeof callback !== 'function') {
      return;
    }
    var node;

    for (node in nodes) {
      if (callback(nodes[node])) {
        return true; // client doesn't want to proceed. Return.
      }
    }
  }
}

// need this for old browsers. Should this be a separate module?
function indexOfElementInArray(element, array) {
  if (!array) return -1;

  if (array.indexOf) {
    return array.indexOf(element);
  }

  var len = array.length,
    i;

  for (i = 0; i < len; i += 1) {
    if (array[i] === element) {
      return i;
    }
  }

  return -1;
}

/**
 * Internal structure to represent node;
 */
function Node(id) {
  this.id = id;
  this.links = null;
  this.data = null;
}

function addLinkToNode(node, link) {
  if (node.links) {
    node.links.push(link);
  } else {
    node.links = [link];
  }
}

/**
 * Internal structure to represent links;
 */
function Link(fromId, toId, data, id) {
  this.fromId = fromId;
  this.toId = toId;
  this.data = data;
  this.id = id;
}

function hashCode(str) {
  var hash = 0, i, chr, len;
  if (str.length == 0) return hash;
  for (i = 0, len = str.length; i < len; i++) {
    chr   = str.charCodeAt(i);
    hash  = ((hash << 5) - hash) + chr;
    hash |= 0; // Convert to 32bit integer
  }
  return hash;
}

function makeLinkId(fromId, toId) {
  return hashCode(fromId.toString() + '👉 ' + toId.toString());
}

},{"ngraph.events":2}]},{},[1]);
