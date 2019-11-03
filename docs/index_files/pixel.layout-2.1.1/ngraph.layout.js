(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
layout_static = require('pixel.static')

},{"pixel.static":2}],2:[function(require,module,exports){
module.exports = layout;

function layout(graph, options) {
  options = options || {};
  var initPos = typeof options.initPosition === 'function' ? options.initPosition : initPosDefault;

  var api = {
    step: function noop() { return true; },

    /**
     * Gets position of a given node by its identifier. Required.
     *
     * @param {string} nodeId identifier of a node in question.
     * @returns {object} {x: number, y: number, z: number} coordinates of a node.
     */
    getNodePosition: getNodePosition
  };

  var positions = {};
  graph.forEachNode(setInitialPosition);

  return api;

  function setInitialPosition(node) {
    positions[node.id] = initPos(node);
  }

  function getNodePosition(nodeId) {
    return positions[nodeId];
  }

  function initPosDefault(node) {
    positions[node.id] = node.data;
  }
}

},{}]},{},[1]);
