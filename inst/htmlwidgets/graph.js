HTMLWidgets.widget({

  name: 'graph',

  type: 'output',

  factory: function(el, width, height) {

    var renderer, g;

    return {

      renderValue: function(x) {

        g = createGraph();

        // update
        if(x.bulk) g.beginUpdate();

        if(x.nodes)
          x.nodes.forEach(function(node){
            g.addNode(node[0], node[1])
          })
        
        if(x.links)
          x.links.forEach(function(link){
            g.addLink(link[0], link[1])
          })

        if(x.bulk) g.endUpdate();

        x.layout.container = document.getElementById(el.id);

        function get_node_position(node) {
          return {
            x: node.data.x,
            y: node.data.y,
            z: node.data.z
          };
        };

        if(x.customLayout){
          x.layout.createLayout = layout_static;
          x.layout.initPosition = get_node_position;
        }

        if(x.render)
          renderer = pixel(g, x.layout)
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      },
      getGraph: function(){
        return g;
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

if (HTMLWidgets.shinyMode) {
  
  // Add node
  Shiny.addCustomMessageHandler('add-nodes',
    function(msg) {
      var chart = get_graph(msg.id);
      if (typeof chart != 'undefined') {
        msg.nodes.forEach(function(node){
          g.addNode(node)
        })
      }
  });

  // Add links
  Shiny.addCustomMessageHandler('add-links',
    function(msg) {
      var chart = get_graph(msg.id);
      if (typeof chart != 'undefined') {
        msg.links.forEach(function(link){
          g.addLink(links)
        })
      }
  });

}
