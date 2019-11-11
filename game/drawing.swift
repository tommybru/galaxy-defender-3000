//  drawing.swift
//  galaxy-defender-3000
//
//  Created by Tommy Bruzzese on 1/24/17.
//
// This app spawns aliens randomly from different sides of the screen,
// increasing the amount that spawns and the game difficulty as a player scores
// more. The player's goal is to shoot away as many aliens as possible
// and protect their space orbs from being hit for as long as possible.

import UIKit

var firstTimePlaying = true
var firstClick = true
var firstRemove = true
var score = 0
var gameover = false

var forcefieldscore = 2500
var forcefield = false
var gracemode = false
var gracemodecount = 0
var freeze = false
var freezecount = 0
var bossmode = false
var difficulty:Int = 0
var alienStrength:Int = 0
var generateAlienIfZero = -1
var alienSpawningRandomizer = -1
var bossSpawnRandomizer = -1
var velocitychanger:CGFloat = 0.0
var shipexplode = 7

var pointOnCircle = object()
var distanceBetween: Double = 0.0
var xSide = 0
var ySide = 0
var hypo: Double = 0.0
var xSideOG = 0
var ySideOG = 0

var bullets: [object] = []
var orbs: [object] = []
var aliens: [object] = []
var myShip = object()
var images: [UIImage] = []

class object {
    var height:CGFloat = 0.0
    var width:CGFloat = 0.0
    var myRectangle = CGRect()
    var imageArray : [UIImage] = []
    var locX:CGFloat = 0.0
    var locY:CGFloat = 0.0
    var inputColor = UIColor.red.cgColor
    var dx:CGFloat = 0.0
    var dy:CGFloat = 0.0
    var ship = false
    var boss = false
    var boss2 = false
    var imageOfOrbs:UIImage = UIImage(named: "orbs2-min.png")!
    var imageOfOrbs2:UIImage = UIImage(named: "orbs2-min-forcefield.png")!
    var imageOfShip:UIImage = UIImage(named: "alien-spaceship-min.png")!
    var imageOfShip2:UIImage = UIImage(named: "alien-ship-2-min.png")!
    var imageOfShip3:UIImage = UIImage(named: "frozen-ship.png")!

    var explode1:UIImage = UIImage(named: "spaceship-explosion-1-min.png")!
    var explode2:UIImage = UIImage(named: "spaceship-explosion-2-min.png")!
    var explode3:UIImage = UIImage(named: "spaceship-explosion-3-min.png")!
    var explode4:UIImage = UIImage(named: "spaceship-explosion-4-min.png")!

    init() {
        myRectangle = CGRect(x: locX, y: locY, width: width, height: height)
    }
    func setRandomSpot(xLimit:CGFloat, y: CGFloat) {
        locX = CGFloat(UInt32(arc4random())%(UInt32(xLimit)))
        locY = y
        placeMe()
    }
    func gotPokedBy(x: CGFloat, y: CGFloat) -> Bool {
        if x > locX && x < locX + height && y > locY && y < locY + height {
            return true
        }
        return false
    }
    func initShip() {
        height = 100
        width = 150
        inputColor = UIColor.blue.cgColor
        locX = (theView.frame.size.width/2) - width/2
        locY = (theView.frame.size.height/2) - height/2
        placeMe()
    }
    func initAlien() {
        height = 40
        width = 40
        inputColor = UIColor.green.cgColor
        placeMe()

    }
    func initBullet(xDest: CGFloat, yDest: CGFloat) {
        height = 8
        width = 8
        locX = (theView.frame.size.width/2) - width/2
        locY = (theView.frame.size.height/2) - height/2
        inputColor = UIColor.white.cgColor
        xSide = Int(xDest)-Int(locX)
        ySide = Int(yDest)-Int(locY)
        distanceBetween = Double((xSide*xSide) + (ySide*ySide))
        hypo = sqrt(3000)
        dx = CGFloat(Double(xSide)/hypo)
        dy = CGFloat(Double(ySide)/hypo)
        placeMe()

    }
    func drawMe(placeToDraw: CGContext, type: Int) {
        if type == 0 {
            placeToDraw.addEllipse(in: myRectangle)
        }
        if type == 1 {
            imageOfShip.draw(in: myRectangle)
        }
        if type == 4 {
            imageOfShip2.draw(in: myRectangle)
        }
        if type == 2 {
            imageOfOrbs.draw(in: myRectangle)
        }
        if type == 3 {
            placeToDraw.addRect(myRectangle)
        }
        if type == 5 {
            imageOfOrbs2.draw(in: myRectangle)
        }
        if type == 6 {
            imageOfShip3.draw(in: myRectangle)
        }
        if type == 7 {
            explode1.draw(in: myRectangle)
        }
        if type == 8 {
            explode2.draw(in: myRectangle)
        }
        if type == 9 {
            explode3.draw(in: myRectangle)
        }
        if type == 10 {
            explode4.draw(in: myRectangle)
        }
        placeToDraw.setFillColor(inputColor)
        placeToDraw.fillPath()
    }
    func isTouching(otherObject: object, object: CGRect) -> Bool {
        var tanOfCenters:CGFloat = 0.0
        var XOfPointOnCircle:CGFloat = 0.0
        var YOfPointOnCircle:CGFloat = 0.0
        if locX > otherObject.locX {
            if locY > otherObject.locY {
                tanOfCenters = atan2(locY - otherObject.locY, locX - otherObject.locX)
                YOfPointOnCircle = otherObject.locY + (sin(tanOfCenters) * otherObject.width)/2 + otherObject.width/2
            }
            else {
                tanOfCenters = atan2(otherObject.locY - locY, locX - otherObject.locX)
                YOfPointOnCircle = otherObject.locY - (sin(tanOfCenters) * otherObject.width)/2  + otherObject.width/2
            }
            XOfPointOnCircle = otherObject.locX + (cos(tanOfCenters) * otherObject.width)/2  + otherObject.width/2
        }
        else {
            if locY > otherObject.locY {
                tanOfCenters = atan2(locY - otherObject.locY, otherObject.locX - locX)
                YOfPointOnCircle = otherObject.locY + (sin(tanOfCenters) * otherObject.width)/2  + otherObject.width/2
            }
            else {
                tanOfCenters = atan2(otherObject.locY - locY, otherObject.locX - locX)
                YOfPointOnCircle = otherObject.locY + (sin(tanOfCenters) * otherObject.width)/2  + otherObject.width/2

            }
            XOfPointOnCircle = otherObject.locX - (cos(tanOfCenters) * otherObject.width)/2  + otherObject.width/2
        }

        pointOnCircle.myRectangle = CGRect(x: XOfPointOnCircle, y: YOfPointOnCircle, width: 5, height: 5)
        pointOnCircle.inputColor = UIColor.blue.cgColor

        if object.intersects(pointOnCircle.myRectangle) {
            return true
        }

        return false
    }
    func freezeMe() {
        dx = 0
        dy = 0
    }
    func moveMe() {
        locX += dx
        locY += dy
        placeMe()
    }
    func giveorbsLoc(x: Int) {
        if x == 0 {
            locX = (theView.frame.size.width/2) - width/2
            locY = ((theView.frame.size.height/2) - height/2) - (theView.frame.size.height/7)
        }
        if x == 1 {
            locX = ((theView.frame.size.width/2) - width/2) - (theView.frame.size.width/6)
            locY = ((theView.frame.size.height/2) - height/2) + (theView.frame.size.height/8)
        }
        if x == 2 {
            locX = ((theView.frame.size.width/2) - width/2) + (theView.frame.size.width/6)
            locY = ((theView.frame.size.height/2) - height/2) + (theView.frame.size.height/8)
        }
    }
    func placeMe() {
        myRectangle = CGRect(x: locX, y: locY, width: width, height: height)
    }
}

func createorbs() {
    for x in 0...2 {
        orbs.append(object())
        orbs[x].width = 75.0
        orbs[x].height = 75.0
    }
}

func createABullet() {
    bullets.append(object())
}

func addAnAlien(side: Int, bossnum: Int) {
    aliens.append(object())
    if difficulty == 1 && alienStrength != 2 {
        if side == 1 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: theView.frame.size.height)
            aliens.last?.dy = -1.5 - velocitychanger
            aliens.last?.dx = -1 - velocitychanger
        }
        if side == 2 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: theView.frame.size.height)
            aliens.last?.dy = -1 - velocitychanger
            aliens.last?.dx = 1.5 + velocitychanger
        }
        if side == 3 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: 0)
            aliens.last?.dy = 1.5 + velocitychanger
            aliens.last?.dx = 1.5 + velocitychanger
        }
        if side == 4 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: theView.frame.size.height)
            aliens.last?.dy = -1.5 - velocitychanger
            aliens.last?.dx = 0
        }
        if side == 0 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: 0)
            aliens.last?.dy = 1 + velocitychanger
            aliens.last?.dx = 1 + velocitychanger
        }
        if bossnum == 2 {
            aliens.last?.boss = true
        }
    }
    if difficulty == 1 && alienStrength == 2 {
        if side == 1 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: theView.frame.size.height)
            aliens.last?.dy = -1.75 - velocitychanger
            aliens.last?.dx = -1.25 - velocitychanger
        }
        if side == 2 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: theView.frame.size.height)
            aliens.last?.dy = -1.25 - velocitychanger
            aliens.last?.dx = 1.75 + velocitychanger
        }
        if side == 3 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: 0)
            aliens.last?.dy = 1.75 + velocitychanger
            aliens.last?.dx = 1.75 + velocitychanger
        }
        if side == 4 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: theView.frame.size.height)
            aliens.last?.dy = -1.75 - velocitychanger
            aliens.last?.dx = 0
        }
        if side == 0 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: 0)
            aliens.last?.dy = 1 + velocitychanger
            aliens.last?.dx = 1 + velocitychanger
        }
        if bossnum == 2 || bossnum == 1 {
            aliens.last?.boss = true
        }
        if bossnum == 4 || bossnum == 3 {
            aliens.last?.boss2 = true
        }

    }
    else {
        if side == 0 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: 0)
            aliens.last?.dy = 1
            aliens.last?.dx = 1
        }
        if side == 1 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: theView.frame.size.height)
            aliens.last?.dy = -1
            aliens.last?.dx = -1
        }
        if side == 2 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: theView.frame.size.height)
            aliens.last?.dy = -1
            aliens.last?.dx = 1
        }
        if side == 3 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: 0)
            aliens.last?.dy = 1
            aliens.last?.dx = 1
        }
        if side == 4 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: theView.frame.size.height)
            aliens.last?.dy = -1
            aliens.last?.dx = 0

        }
        if side == 0 {
            aliens.last?.setRandomSpot(xLimit: theView.frame.size.width, y: 0)
            aliens.last?.dy = 1
            aliens.last?.dx = 1

        }

    }
    aliens.last?.initAlien()

}


class drawing: UIView {
    var zerolabel: UILabel
    var label: UILabel
    var label1: UILabel
    var label2: UILabel
    var label3: UILabel
    override init(frame:CGRect) {
        zerolabel = UILabel(frame: CGRect(x: 7*(frame.width/8) + 75, y:10, width:150, height: 75))
        zerolabel.text = String(0);
        zerolabel.font = UIFont(name: "Helvetica", size: 48);
        zerolabel.textColor = UIColor.magenta;
        label = UILabel(frame: CGRect(x: 7*(frame.width/8) + 25, y:10, width:150, height: 75))
        label.text = String(0);
        label.font = UIFont(name: "Helvetica", size: 48);
        label.textColor = UIColor.magenta;
        label1 = UILabel(frame: CGRect(x: 7*(frame.width/8), y:10, width:150, height: 75))
        label1.text = String(0);
        label1.font = UIFont(name: "Helvetica", size: 48);
        label1.textColor = UIColor.magenta;
        label2 = UILabel(frame: CGRect(x: 7*(frame.width/8)-25, y:10, width:150, height: 75))
        label2.text = String(0);
        label2.font = UIFont(name: "Helvetica", size: 48);
        label2.textColor = UIColor.magenta;
        label3 = UILabel(frame: CGRect(x: 7*(frame.width/8)-50, y:10, width:150, height: 75))
        label3.text = String(0);
        label3.font = UIFont(name: "Helvetica", size: 48);
        label3.textColor = UIColor.magenta;
        super.init(frame: frame)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        self.backgroundColor = UIColor.black
        self.clearsContextBeforeDrawing = true
        self.addSubview(zerolabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let theFinger = touches.first!
        let theX = theFinger.location(in: self).x
        let theY = theFinger.location(in: self).y
        myShip.ship = true
        if firstClick {
            createorbs()
            myShip.initShip()
            for x in 0..<orbs.count {
                orbs[x].giveorbsLoc(x: x)
                orbs[x].placeMe()
            }
            if firstTimePlaying {
                var _ = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(@objc(self.update)), userInfo: nil, repeats: true)
                var gg = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(@objc(self.explode)), userInfo: nil, repeats: true)
                firstTimePlaying = false
            }


            firstClick = false
        }
        else if !freeze {
            createABullet()
        }
        bullets.last?.initBullet(xDest: theX, yDest: theY)
        if myShip.gotPokedBy(x: theX, y: theY) && forcefield {
            gracemode = true
            forcefield = false
        }
    }


    func explode() {
        if gameover {
            if shipexplode < 10 {
                shipexplode += 1
            }
        }
    }

    func update() {
        if freeze {
            freezecount += 1
        }
        if freezecount == 250 {
            freeze = false
            freezecount = 0
        }
        if gracemode {
            gracemodecount += 1
        }
        if gracemodecount == 600 {
            gracemode = false
            gracemodecount = 0
        }

        //Probability an alien will be generated increases as difficulty increases
        generateAlienIfZero = Int(arc4random()%UInt32((3*((10-difficulty)*(10-difficulty))/8)))
        if !bossmode {
            if generateAlienIfZero == 0 {
                alienSpawningRandomizer = Int(arc4random()%5)
                addAnAlien(side: alienSpawningRandomizer, bossnum: 0)
            }
        }
        else if alienStrength != 2 {
            if generateAlienIfZero == 0 {
                alienSpawningRandomizer = Int(arc4random()%5)
                bossSpawnRandomizer = Int(arc4random()%3)
                addAnAlien(side: alienSpawningRandomizer, bossnum: bossSpawnRandomizer)
            }
        }
        else {
            if generateAlienIfZero == 0 {
                alienSpawningRandomizer = Int(arc4random()%5)
                bossSpawnRandomizer = Int(arc4random()%6)
                addAnAlien(side: alienSpawningRandomizer, bossnum: bossSpawnRandomizer)
            }
        }
        for x in 0..<aliens.count {
            if x <= aliens.count - 1 {
                if myShip.isTouching(otherObject: aliens[x], object: myShip.myRectangle) {
                    freeze = true
                }
                aliens[x].moveMe()
                if aliens[x].boss {
                    aliens[x].inputColor = UIColor.red.cgColor
                }
                if aliens[x].boss2 {
                    aliens[x].inputColor = UIColor.blue.cgColor
                }
                if aliens[x].locX < -50 || aliens[x].locX > self.frame.width + 5 {
                    aliens.remove(at: x)
                }
                for y in 0..<orbs.count {
                    if x <= aliens.count - 1 {
                        if y <= orbs.count - 1 {
                            if aliens[x].isTouching(otherObject: orbs[y], object: aliens[x].myRectangle) {
                                if !gracemode {
                                    orbs.remove(at: y)
                                    score += -1000
                                }
                                else {
                                    aliens.remove(at: x)
                                }
                            }
                        }
                    }
                }
                for y in 0..<bullets.count {
                    if x <= aliens.count - 1 {
                        if y <= bullets.count - 1 {
                            if aliens[x].isTouching(otherObject: bullets[y], object: aliens[x].myRectangle) {
                                if aliens[x].boss {
                                    aliens[x].boss = false
                                    aliens[x].inputColor = UIColor.green.cgColor
                                }
                                else if aliens[x].boss2 {
                                    aliens[x].boss2 = false
                                    aliens[x].boss = true
                                    aliens[x].inputColor = UIColor.red.cgColor
                                }
                                else {
                                    aliens.remove(at: x)
                                    score += 100
                                }
                                bullets.remove(at: y)
                            }
                        }
                    }
                }
            }
        }
        if score == forcefieldscore {
            forcefield = true
            forcefieldscore += 2500
        }
        for x in 0..<bullets.count {
            bullets[x].moveMe()
        }
        if orbs.count == 0 {
            gameover = true
            for x in 0..<bullets.count {
                bullets[x].freezeMe()
            }
            for x in 0..<aliens.count {
                aliens[x].freezeMe()
            }

        }
        //when a player reaches 1500, 3000, and 4500, the game gets harder
        if score % 1500 == 0 {
            if alienStrength == 1 {
                alienStrength += 1
            }
            if difficulty == 0 {
                difficulty += 1
                alienStrength += 1
            }
            if difficulty == 1 {
                bossmode = true
                difficulty += 1
            }
        }
        if score % 800 == 0 {
            velocitychanger += 0.4
        }
        //Updating space for score display (changes based on # of digits)
        if score < 1000 && score > 0 {
            self.addSubview(label)
            zerolabel.removeFromSuperview()
            label.text = String(score)
            label1.removeFromSuperview()
            label2.removeFromSuperview()
            label3.removeFromSuperview()
        }
        if score >= 1000 || score < 0{
            zerolabel.removeFromSuperview()
            label.removeFromSuperview()
            label2.removeFromSuperview()
            label3.removeFromSuperview()
            self.addSubview(label1)
            label1.text = String(score)
        }
        if score >= 10000 || score < -1000{
            label.removeFromSuperview()
            label1.removeFromSuperview()
            label3.removeFromSuperview()
            self.addSubview(label2)
            label2.text = String(score)
        }
        if score >= 100000 || score < -10000{
            label.removeFromSuperview()
            label1.removeFromSuperview()
            label2.removeFromSuperview()
            self.addSubview(label3)
            label3.text = String(score)
        }
        self.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let thisCanvas = UIGraphicsGetCurrentContext()!
        if forcefield {
            myShip.drawMe(placeToDraw: thisCanvas, type: 4)
        }
        else if freeze {
            myShip.drawMe(placeToDraw: thisCanvas, type: 6)
        }
        else if gameover {
            myShip.drawMe(placeToDraw: thisCanvas, type: shipexplode)
        }
        else {
            myShip.drawMe(placeToDraw: thisCanvas, type: 1)
        }
        for x in 0..<orbs.count {
            if gracemode {
                orbs[x].drawMe(placeToDraw: thisCanvas, type: 5)
            }
            else {
                orbs[x].drawMe(placeToDraw: thisCanvas, type: 2)
            }
        }
        for x in 0..<aliens.count {
            aliens[x].drawMe(placeToDraw: thisCanvas, type: 0)
        }
        for x in 0..<bullets.count {
            if !freeze {
                bullets[x].drawMe(placeToDraw: thisCanvas, type: 3)
            }
        }
    }
}
