#!/usr/bin/env node

const WebSocketServer = require('websocket').server;
const http = require('http');
const ngrok = require('ngrok');
const express = require('express');
const path = require('path');
const cors = require('cors');
const bodyParser = require('body-parser');
const utf8 = require('utf8');

const app = express();
//app.use(express.json());

var imageDataJSON;
app.use(cors());
app.options('*', cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("express"));
app.use('/', function(req,res){
  //console.log((new Date()) + ' Received request for ' + res.url);

  if(req.url == '/imageData'){
    console.log("POST");
    imageDataJSON = req.body;
    console.log("Image is: " + imageDataJSON.width + " by " + imageDataJSON.height);
  }
  else if(req.url == '/dimensions'){
    //console.log('GET dimensions');
    if(monitorDim == undefined) res.send('-1');
    else res.send(monitorDim);
  }
  else{
    console.log((new Date()) + ' Received connection from ' + req.url);
    console.log('Sending ' + path.join(__dirname, '/express/index.html'));
    res.sendFile(path.join(__dirname, '/express/index.html'));
    //res.render(path.join(__dirname, '/express/index.html'));
  }
  res.end();
});


//app.listen(8080);

var server = http.createServer(app);
server.listen(8080, function() {
  console.log((new Date()) + ' Server is listening on port 8080');
});
/*server.on('request', function(req){
  console.log(req.protocol + ' protocol connected from ' + req.url);
});*/

var monitorDim;
wsServer = new WebSocketServer({
  httpServer: server,
  autoAcceptConnections: false
});
var dimRequest = utf8.encode(JSON.stringify({"type":"GET_DIM","data":"NONE"}));
//console.log(dimRequest + " " + (typeof dimRequest));
wsServer.on('request', function(request) {

  var connection = request.accept(null, request.origin);
  console.log((new Date()) + ' Connection accepted.');
  //connection.sendUTF('test')
  connection.send(utf8.encode(dimRequest));
  connection.on('message', function(message) {
    //console.log("raw message: " + message.utf8Data);
    let parsed = JSON.parse(message.utf8Data);
    switch(parsed.type){
      case 0:
        //dimensions response
        monitorDim = [parsed.width, parsed.height];
        //console.log('Received Dimensions: %s', monitorDim);
        //getScaledDimensions(monitorDim);
        //send image

        let sendImgData = {
          "type":"IMG",
          "data":"NONE"
        };
        if(imageDataJSON != undefined && imageDataJSON != null &&
          imageDataJSON.width == monitorDim[0] &&
          imageDataJSON.height == monitorDim[1]){
          sendImgData.data = imageDataJSON.stringData;
          //console.log('Sent image');
          imageDataJSON = null;
        }
        connection.send(utf8.encode(JSON.stringify(sendImgData)));
        break;
      case 1:
        //finished image
        connection.sendUTF(dimRequest);
        break;
    }

  });



  connection.on('close', function(reasonCode, description) {
    console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
  });
});

(async function() {
  const url = await ngrok.connect({port:8080});
  console.log('w%s', url.substring(4));
})();

function getScaledDimensions(dim){
  //converts monitor.getSize() dimensions from scale 1 to scale 0.5
  dim[0] = Math.round(21/11 * (dim[0]-7) + 15);
  dim[1] = dim[1]*2;
}





/*
window.onunload(){
  wsServer.close();
};

window.onload = function(){
};

var canvas = document.createElement('canvas');
var context = canvas.getContext('2d');

function getImagePixels(img){
  canvas.width = img.width;
  canvas.height = img.height;
  context.drawImage(img, 0, 0);
  return context.getImageData(0, 0, img.width, img.height);
}

async function getImageFromURL(){
  await new Promise((resolve, reject) => {
    let img = new Image();
    img.onload = () => resolve(img);
    img.onerror = reject;
    img.src = src;
  }).then((img) => {
    console.log(img.height);
  }), reason => {
    alert("Invalid image link.");
    document.getElementById('imageLink').value = "";
  }
}

function convertImage(){

}
*/
