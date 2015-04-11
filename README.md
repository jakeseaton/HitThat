HitThat
=======

Jake Seaton
Quincy-Dewolfe 20-05

Location
---
Code: github.com/jakeseaton/HitThat
Product: N/A

Description
---
HitThat is the only dating app that lets you find singles near you and match, track, and fight them, all with the palm of your hand.

The back end of the app uses Parse, a cloud database service recently acquired by Facebook, allowing server interaction and seamless Facebook integration, for additional features.

**Main**
The main interface is uses an MMDrawerController, giving the user the ability to swipe left to see a menu drawer, and right to see a list of all of their fights.
The menu gives you access to the Versus screen, your profile, and settings.
The right drawer is the fights table.


**Versus**
Presents the comparison in a table view, like sports.

When you decide to fight someone, you press the button, and the view flips over, revealing your opponent's true identity.

When you start a fight, your location is updated in the database, allowing the people that you're currently fighting to find you easier :)

**Fights**
**Open Fights**
When you throw a punch, it updates your location.
**Registration**
The user logs in with facebook, giving the app access to their profile and basic information, such as name and gender. This also initializes their location, because Facebook tracks that apparently.
**Profile**
View the number of fights you've won and lost, and your number of current fights. Edit your profile to change what potential opponents see when they decide whether or not they want to fight you.

Pods
---
Parse
MMDrawerController
MotionKit
FXBlurView
FXForms
YLProgressBar
ZLSwipeableView

**Notes:** Pods were installed manually, so you won't have to run pod install or worry about a workspace file. Sue me.

To Use
---
1) Open the HitThat.xcodeproj file.

2) Set the build destination to the simulator's iphone 5s or your ios device.

3) Press play

**Notes:**
- You'll need to build it to an ios device to experience all of the functionality. For that you'll need an apple developer account.

-It was developed specifically for the iphone 5s running ios 8, because that's the hardward I had access to. It has only been tested on this and the simulator.


Test Users
---

Known Issues
--- 
May be some memory gremlins that would be solved by a few “unowned self” prefaces in callbacks and closures.

Due to my reuse of the registration for for editing the profile, you must rebuild all fields of the profile to save changes. Easily solved by creating a new form with default values set to the user’s current state.

PFQuery does not support ordering on .orQueryWithsSubQuery queries, which is the way that I am getting all fights a user is involved in.
Haven't been doing capture lists -> some strong reference cycles
Not the prettiest app in the world.

Apple decided to release an update to swift and xcode that is incompatible with the previous version. This will not run in XCode 6.3 or with swift 1.2
It won't play custom sounds on incoming notifications.

