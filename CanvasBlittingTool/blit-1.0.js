(function (){
 
    var blitters = {};

    //Set up requestAnimation with a timeout fallback
    window.requestAnimFrame = (function(){
                               return  window.requestAnimationFrame     ||
                               window.webkitRequestAnimationFrame       ||
                               window.mozRequestAnimationFrame          ||
                               function( callback ){
                                    window.setTimeout(callback, 1000 / 60);
                               };
    })();

    //The animation loop
    (function animloop(){
        requestAnimFrame(animloop);
     
        //Step all of the blitters
        for(var id in blitters)
        {
            blitters[id].step();
        }
    })();

    //Blit one frame for the given blitter
    function blit(blitter)
    {
        for (var i = 0; i < blitter.frameData[blitter.frame].length; i++)
        {
            var blit = blitter.frameData[blitter.frame][j];
            var size = blitter.cellSize;
            blitter.ctx.drawImage(blitter.image, blit[0]*size, blit[1]*size, size, size, blit[2]*size, blit[3]*size, size, size);
        }
    }

    //Sets up blitting with the given manifest and image on the canvas with the given ID
    function blit_init(canvasID, manifestName, imageName)
    {
        var blitter;
        loadJSON(manifestName, function(response) {
                 var json = JSON.parse(response);
                 if (json.version > 1)
                 {
                    console.log("This version of blit not compatible with this manifest");
                    return;
                 }
                 
                 var image = new Image();
                 image.onload = function(){
                 
                    blitter = new Blitter(canvasID, json.frameCount, json.frameRate, json.frames, json.cellSize, image);
                    blitters[canvasID] = blitter;
                 }
                 image.src = imageName;
        });
    }

    //Starts or resumes the animation
    function blit_resume(canvasID)
    {
        blitters[canvasID].paused = false;
    }

    //Pauses the animation
    function blit_pause(canvasID)
    {
        blitters[canvasID].paused = true;
    }
 
    //The blitter "class"
    function Blitter(id, frames, fps, frameData, cellSize, image) {
        this.id = id;
        this.context = document.getElementById(id).getContext('2d');
        this.fps = fps;
        this.frame = 0;
        this.frames = frames;
        this.frameData = [];
        this.frameWait = Math.round(60/fps);
        this.frameTimer = 0;
        this.cellSize = cellSize;
        this.image = image;
        this.paused = false;
        this.imageLoaded = false;
        this.step = function() {
            //Renders if neccesary
            if ((this.frameTimer === 0) && (!this.paused))
            {
                blit(this);
                this.frame++;
                //When we reach the end, pause and reset the animation
                if (this.frame > this.frames - 1)
                {
                    this.paused = true;
                    this.frame = 0;
                    this.frameTimer = 0;
                }
            }
            //Continue the frame timer
            this.frameTimer = (this.frameTimer - 1) % frameWait;
        };
    }
 
    function loadJSON(file, callback) {
        var request = new XMLHttpRequest();
        request.overrideMimeType("application/json");
        request.open('GET', file, false); // Replace 'my_data' with the path to your file
        request.onreadystatechange = function () {
            if (request.readyState == 4 && request.status == "200")
            {
                callback(request.responseText);
            }
        };
        request.send(null);
    }
}());


