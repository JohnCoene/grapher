HTMLWidgets.widget({

  name: 'graph',

  type: 'output',

  factory: function(el, width, height) {

    var renderer, g;
    var layout =  [];

    return {

      renderValue: function(x) {

        g = createGraph();

        // update according to data
        if(x.hasOwnProperty('gexf'))
          g = load_gexf.load(x.gexf);
        else if (x.hasOwnProperty('dot'))
          g = ngraph_fromdot(x.dot, g);
        else
          g = from_json(x.data);
        
        layout = x.layout;
        layout.clearColor = '0x' + layout.clearColor.substr(1);

        layout.container = document.getElementById(el.id);

        if(x.offline_nodes){
          var cnt = 0;
          g.forEachNode(function(node){
            node.data.x = x.offline_nodes[cnt].x;
            node.data.y = x.offline_nodes[cnt].y;
            node.data.z = x.offline_nodes[cnt].z;
            cnt += 1;
          })
        }

        function get_node_position(node) {
          return {
            x: node.data.x,
            y: node.data.y,
            z: node.data.z
          };
        };

        if(x.customLayout){
          layout.createLayout = layout_static;
          layout.initPosition = get_node_position;
        }

        layout.node = function createNodeUI(node) {
          var c = 0xFFFFFF;
          if(node.data) 
            if(node.data[x.style.nodes.color]) 
              c = '0x' + node.data[x.style.nodes.color].substr(1);
            
          var s = 30;
          if(node.data) 
            if(node.data[x.style.nodes.size]) 
              s = node.data[x.style.nodes.size];
          
          return {
            color: c,
            size: s
          };
        };

        layout.link = function createNodeUI(link) {
          
          var fromc = 0xFFFFFF;
          if(link.data) 
            if(link.data[x.style.links.fromColor]) 
              fromc = '0x' + link.data[x.style.links.fromColor].substr(1);
            
          var toc = 0xFFFFFF;
          if(link.data) 
            if(link.data[x.style.links.toColor]) 
              toc = '0x' + link.data[x.style.links.toColor].substr(1);
          
          return {
            fromColor: fromc,
            toColor: toc
          };
        };

        if(x.draw)
          renderer = pixel(g, layout);

        if (HTMLWidgets.shinyMode) {
          if(x.on_node_click)
            renderer.on('nodeclick', function(node) {
              Shiny.setInputValue(el.id + '_node_click' + ":grapherParser", node);
            });

          if(x.on_node_double_click)
            renderer.on('nodedblclick', function(node) {
              Shiny.setInputValue(el.id + '_node_double_click' + ":grapherParser", node);
            });

          if(x.on_node_hover)
            renderer.on('nodehover', function(node) {
              Shiny.setInputValue(el.id + 'node_hover' + ":grapherParser", node);
            });
        }
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      },
      getGraph: function(){
        return g;
      },
      getRenderer: function(){
        return renderer;
      }

    };
  }
});

function get_graph(id){

  var htmlWidgetsObj = HTMLWidgets.find("#" + id);

  var g;

  if (typeof htmlWidgetsObj != 'undefined') {
    g = htmlWidgetsObj.getGraph();
  }

  return(g);
}

function get_renderer(id){

  var htmlWidgetsObj = HTMLWidgets.find("#" + id);

  var r;

  if (typeof htmlWidgetsObj != 'undefined') {
    r = htmlWidgetsObj.getRenderer();
  }

  return(r);
}

if (HTMLWidgets.shinyMode) {
  
  // Add node
  Shiny.addCustomMessageHandler('add-nodes',
    function(msg) {
      var g = get_graph(msg.id);
      if (typeof g != 'undefined') {
        msg.nodes.forEach(function(node){
          g.addNode(node);
        })
      }
  });

  // Add links
  Shiny.addCustomMessageHandler('add-links',
    function(msg) {
      var g = get_graph(msg.id);
      if (typeof g != 'undefined') {
        msg.links.forEach(function(link){
          g.addLink(link[0], link[1], link[2]);
        })
      }
  });

  // Redraw
  Shiny.addCustomMessageHandler('draw',
    function(msg) {
      var r = get_renderer(msg.id);
      if (typeof r != 'undefined') {
        r.redraw();
      }
  });

  // remove nodes
  Shiny.addCustomMessageHandler('remove-nodes',
    function(msg) {
      var g = get_graph(msg.id);
      if (typeof g != 'undefined') {
        msg.data.forEach(function(id){
          g.removeNode(id);
        });
      }
  });

  // remove links
  Shiny.addCustomMessageHandler('remove-links',
    function(msg) {
      var g = get_graph(msg.id);
      if (typeof g != 'undefined') {
        var lnk;
        msg.links.forEach(function(link){
          lnk = g.getLink(link.source, link.target);
          g.removeLink(lnk);
        });
      }
  });

  // pin nodes
  Shiny.addCustomMessageHandler('pin-nodes',
    function(msg) {
      var g = get_graph(msg.id);
      var r = get_renderer(msg.id);
      if (typeof g != 'undefined') {
        var layout = r.layout;
        msg.nodes.forEach(function(node){
          layout(g).pinNode(node, true)
        });
      }
  });

  // change dimensions
  Shiny.addCustomMessageHandler('change-dim',
    function(msg) {
      var g = get_graph(msg.id);
      var r = get_renderer(msg.id);
      if (typeof g != 'undefined') {
        var layout = r.layout;
        layout(g).is3d(msg.is3d);
      }
  });

  // change background
  Shiny.addCustomMessageHandler('background',
    function(msg) {
      var r = get_renderer(msg.id);
      if (typeof r != 'undefined') {
        r.clearColor('0x' + msg.color.substr(1));
        r.clearAlpha(msg.alpha);
      }
  });


  // change background
  Shiny.addCustomMessageHandler('camera-fov',
    function(msg) {
      var g = get_graph(msg.id);
      var r = get_renderer(msg.id);
      if (typeof r != 'undefined') {
        r.camera(g).fov = msg.fov;
      }
  });
}
