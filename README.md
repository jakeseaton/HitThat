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

Log in with facebook to create a fighter profile, and see other potential fights near you one at a time. You can even commpare your stats to determine your odds! Once you decide to fight someone, you'll be able to see their location, and get more information about them. Too far away? No problem. You can fight them inside the app! Throw the first punch to start a fight. When it's your turn, you can jab, kick, uppercut, or block. The harder you swing, the more damage you do. 
    After the fights, you'll still have access to their profile and basic information, if you still want to hit that.

The app is written in Swift 1.1, using XCode 6.2. It was developed and tested on an iPhone 5s, and is meant to be run on hardware. As its back end, the app uses Parse, a cloud database service recently acquired by Facebook, allowing server interaction and Facebook integration. Information is stored in four tables here: Installations, Users, Fights, and Wins. The first associates the second with hardware, allowing push notifications to be sent to the correct devices.

**Main**
The main interface uses an MMDrawerController, giving the user the ability to swipe left to see a menu drawer, and right to see a fights drawer. The menu drawer displays their alias photo at the top, and allows them to navigate between the versus screen, profiles, and other supplementary features. The fights drawer displays their activity; users they're currently fighting, and those they've defeated or been defeated by. By selecting an active fight, they are taken to a page displaying both user's current stamina, where, on their turn, they can make their move. By selecting fights that they've won or lost, they can view those users' basic profiles.
When the app is opened from a notification, it should take you directly to the fight in question. When the app is open and someone punches you, the app will take you directly to the fight in question. When the app is open to that particular fight, the fight will update automatically. So if someone sitting next to you punches you in the app, and you're viewing that fight, you will see your stamina decrease in real time, though they could have just punched you instead.

**Versus**
This is the main interface for finding potential matches. The fighters' alias' are displayed opposite the versus icon, and the user is presented with a portion of an image, and the information from the other user's fighter profile. The table compares the users stats to their opponents, using simple visual indicators to help the user make an informed decision. For example, if the user has spent more time in jail than their opponent, their opponent's jail time will be displayed in green.

If the user decides not to fight, they can press the "No Way" button to progress to the next potential fight. If they decide to fight, they press the "Fight" button, and the view animates to reveal the opponent's true identity. From this screen, the user can start the fight and throw the first punch, or track their opponent down using the map, which when prompted plots the route from the user's location to their opponent. These locations are updated every time fights are started or punches are thrown. Additionally

**Profiles**
View the number of fights you've won and lost, and your number of current fights. Edit your profile to change what potential opponents see when they decide whether or not they want to fight you. You can view the profiles of users that you've fought by finding them among your wins or losses.

**Fights**
On the open fight screen, you'll see your stamina and your opponents. If it's your turn, press the punch button to tell the app that you're going to punch. Thrust forward to Jab. Make sure to get a good rotation. Thrust upward to uppercut. Thrust your entire arm forward to block. The harder you thrust, the more damage you do!
(Under the hood, this is based on negative acceleration thresholds. When you thrust the phone in a particular direction, the greatest acceleration occurs in the opposite direction, when the motion ends abruptly and your hand applied force to the phone to get it to stop moving. So, if we get a highly positive Z acceleration, we know that the user has thrust the forward along the Z axis, as occurs when thrusting the arm when blocking a punch. Then, by setting an acceleration threshold, as soon as one of the directions crosses it we know the completed an action in that direction. 
![alt tag](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIAcceleration_Class/Art/device_axes.jpg)

The natural punching motion seen here rotates the phone so that it travels in the negative x direction if the user is right handed, and positive if left. When the accelerometer reports a high x acceleration, we know that the user punched. 
![alt tag](http://heavyfists.com/wp-content/uploads/boxing-combinations.jpgrotates) 


Similarly, the uppercut motion causes the phone to travel in positive y direction, so a high negative y acceleration corresponds to an uppercut

![alt tag](http://games.yasinka.com/resimorj/boxing-bonanza.jpg)

To Use
---
1) Open HitThat.xcodeproj.

2) Set the build destination to the simulator's iphone 5s or your ios device.

3) Press play

**Notes:**
- You'll need to build it to an ios device to experience all of the functionality. For that you'll need an apple developer account.

- It was developed specifically for the iphone 5s running ios 8, because that's the hardward I had access to. It has only been tested on this and the simulator.

- Build using XCode 6.2, not 6.3. 6.3 is the way of the past.



Pods
---
Parse (Back End)
MMDrawerController (Main Drawer)
MotionKit (CoreMotion Wrapper)
FXBlurView (Used in Versus Screen to create scroll animation)
YLProgressBar (Stamina Bars)
FXForms (Used in registration and profile updates)
ZLSwipeableView (Registration cards)

**Notes:** Pods were installed manually, so you won't have to run pod install or use a workspace file. Sue me.


Test Users
---


Known Issues
--- 

May be some memory gremlins due to swift's whole "memory is managed for you except its not" thing. Would be solved by captures lists on closures, and a single Model/API struct.

To update your profile you must rebuild it entirely, as I simply reused the registration form. This would be solved by creating a new form with default values set to the user’s current state.

PFQuery does not support ordering on .orQueryWithsSubQuery, which is the only way to get all fights a user is involved in. As such, the fights table cannot be ordered by most recently updated, but will remain in the order they are created.

On April 8th Apple released updates to Swift and Xcode that are not backward compatible. This will not run in XCode 6.3 or with Swift 1.2
