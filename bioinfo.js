if (document.images) {
  var button1 = new Image();
  button1.src = "/ESST/images/yellowOFF.jpg";
  var button1_on = new Image();
  button1_on.src = "/ESST/images/yellowON.jpg";
  var button2 = new Image();
  button2.src = "/ESST/images/yellowOFF.jpg";
  var button2_on = new Image();
  button2_on.src = "/ESST/images/yellowON.jpg";
  var button3 = new Image();
  button3.src = "/ESST/images/yellowOFF.jpg";
  var button3_on = new Image();
  button3_on.src = "/ESST/images/yellowON.jpg";
  var button4 = new Image();
  button4.src = "/ESST/images/yellowOFF.jpg";
  var button4_on = new Image();
  button4_on.src = "/ESST/images/yellowON.jpg";
  var button5 = new Image();
  button5.src = "/ESST/images/yellowOFF.jpg";
  var button5_on = new Image();
  button5_on.src = "/ESST/images/yellowON.jpg";
}

function act(imgName) {
  if (document.images) 
    document[imgName].src = eval(imgName + '_on.src');
}
function inact(imgName) {
  if (document.images)
    document[imgName].src = eval(imgName + '.src');
}
