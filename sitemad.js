//====================================================================================================================
//
//  Dungeon Dice Bot 
//  Author: Fish
//  Version: 1.0.0
//  Will-To-Live: Low
// 
//====================================================================================================================

const Path = require("path")
const fs = require("fs");
const { writer } = require("repl");

var logger = fs.createWriteStream('sitemap.md', {
    flags: 'a'
})
    
function ThroughDirectory(Directory, currDepth) {

    fs.readdirSync(Directory).forEach(File => {

        const Absolute = Path.join(Directory, File)
        var depth = ""

        if (fs.statSync(Absolute).isDirectory()){
            depth += "\n## "
            depth += File + "\n"
            logger.write(depth)
            return ThroughDirectory(Absolute, currDepth + 1)
        } 
        else {
            depth += "- [" + File.substring(0,File.length - 3) + "](" + Absolute + ")\n"
            logger.write(depth)
        }

    });

}

function guh() {

    logger.write("# Snackvivor Sitemap\n")


    ThroughDirectory("./Snackvivor-Season-1", 0)

}

guh()
