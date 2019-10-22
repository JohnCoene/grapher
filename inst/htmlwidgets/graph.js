HTMLWidgets.widget({

  name: 'graph',

  type: 'output',

  factory: function(el, width, height) {

    var renderer, g;
    var layout =  [];

    return {

      renderValue: function(x) {

        g = createGraph();

        // update
        if(!x.hasOwnProperty('gexf'))
          g = from_json(x.data);
        else
          g = load_gexf.load(x.gexf)
        
        layout = x.layout;

        layout.container = document.getElementById(el.id);

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
            if(node.data.color) 
              c = '0x' + node.data.color.substr(1);
            
          var s = 30;
          if(node.data) 
            if(node.data.size) 
              s = node.data.size;
          
          return {
            color: c,
            size: s
          };
        };

        layout.link = function createNodeUI(link) {
          
          var fromc = 0xFFFFFF;
          if(link.data) 
            if(link.data.fromColor) 
              fromc = '0x' + link.data.fromColor.substr(1);
            
          var toc = 0xFFFFFF;
          if(link.data) 
            if(link.data.toColor) 
              toc = '0x' + link.data.toColor.substr(1);
          
          return {
            fromColor: fromc,
            toColor: toc
          };
        };

        if(x.draw)
          renderer = pixel(g, x.layout);

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

}
