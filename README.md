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

Log in with facebook to create a fighter profile, and see other potential fights near you one at a time. You can even compare your stats to determine your odds! Once you decide to fight someone, you'll be able to see their location, plot a route to them , and get more information about them. Too far away? No problem. You can fight them inside the app! Throw the first punch to start a fight. When it's your turn, hold the button and swing to punch. The harder you swing, the more damage you do. Try swinging in different directions and at different angles keep them on their toes.
    Win or lose, you'll still have access to their profile in case you still want to hit that.

The app is written in Swift 1.1, using XCode 6.2. It was developed and tested on an iPhone 5s, and is meant to be run on hardware. As its back end, the app uses Parse, a cloud database service recently acquired by Facebook, allowing server interaction and Facebook integration. Information is stored in four tables here: Installations, Users, Fights, and Wins. The first associates the second with hardware, allowing push notifications to be sent to the correct devices. The second stores profile information, statics, and locations. Fights stores pointers to an origin user and a recipient user, as well as their stamina. Wins store pointers to a winner and a loser.

Interface Components
---

**Main:**
The main interface uses an MMDrawerController, giving the user the ability to swipe left to see a menu drawer, and right to see a fights drawer. The menu drawer displays their alias photo at the top, and allows them to navigate between the versus screen, profiles, and other supplementary features. The fights drawer displays their activity; users they're currently fighting, and those they've defeated or been defeated by. By selecting an active fight, they are taken to a page displaying both user's current stamina, where, on their turn, they can make their move. By selecting fights that they've won or lost, they can view those users' basic profiles.

When the app is opened from a notification, it takes you directly to the fight in question. When the app is open and someone punches you, the app will take you directly to that fight. When the app is open to that particular fight, the fight will update automatically. So if someone sitting next to you punches you in the app, and you're viewing that fight, you will see your stamina decrease and hear yourself grunt in real time, though they could have just punched you instead.

**Versus:**
This is the main interface for finding potential matches. The fighters' alias' are displayed opposite the versus icon. The user is presented with a portion of the alias photo chosen during registration and the information from the other user's fighter profile. The table updates automatically and animates like a scoreboard, indicating which fighter has the advantage in what area.

If the user decides not to fight, they can press the "Back Down" button to progress to the next potential fight. If they decide to fight, they press "Hit That!," and the view animates to reveal the opponent's true identity. From this screen, the user can start the fight and throw the first punch, or track their opponent down using the map, which when prompted plots the route from the user's location to their opponent. (Some zooming out may be required to see the whole route).

**Profiles:**
View your number of current fights, and who you've beaten and lost to recently. Edit your profile to change what potential opponents see when they decide whether or not they want to fight you. You'll have to resubmit the registration form.

**Fights:**
On the open fight screen, you'll see your stamina and your opponents. If it's your turn, press the punch button to tell the app that you're going to punch. Thrust forward to Jab, and upward to uppercut.   The harder you thrust, the more damage you do.


(Under the hood, this is based on negative acceleration thresholds. When you thrust the phone in a particular direction, the greatest acceleration occurs in the opposite direction, when the motion ends abruptly and your hand applied force to the phone to get it to stop moving. So, if we get a highly positive Z acceleration, we know that the user has thrust the forward along the Z axis, as occurs when thrusting the arm when blocking a punch. Then, by setting an acceleration threshold, as soon as one of the directions crosses it we know the completed an action in that direction. 


![alt tag](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIAcceleration_Class/Art/device_axes.jpg)

The natural punching motion rotates the phone so that it travels in the negative x direction if the user is right handed, and positive if left. When the accelerometer reports a high x acceleration, we know that the user jabbed. 


![alt tag](http://heavyfists.com/wp-content/uploads/boxing-combinations.jpg) 


Similarly, the uppercut motion causes the phone to travel in positive y direction, so a high negative y acceleration corresponds to an uppercut.

![alt tag](http://games.yasinka.com/resimorj/boxing-bonanza.jpg)

Once the user has completed an action, the euclidean magnitude of the instantaneous acceleration vector tells us how hard they swung, which is then scaled by a constant to calculate damage.

To Use
---
1) Download and unzip

2) Open HitThat.xcodeproj. (It's in there somewhere)

3) Set the build destination to your ios device, or the simulator's iphone 5s.

4) Press play

**Notes:**
- You'll need to build it to an ios device to experience all of the functionality. This requires an apple developer account.

- The app was developed specifically for the iphone 5s running ios 8. It has only been tested on this and the simulator.

- Build using XCode 6.2. XCode 6.3 is the way of the past.


Additional Features
---
- Geographic priority for potential matches presented on the versus screen

- Inability to see the same opponent twice

- Only one fight at a time against a given user

- Turn enfocement. You'll be reminded to wait your turn, but then it becomes your turn automatically, instead of waiting for the other user.


**Notes:** These features hinder testing the app and experiencing it on a small scale, so for the sake of this process they have been commented out.



Pods
---
- Parse (Back End)

- MMDrawerController (Main Drawer)

- MotionKit (CoreMotion Wrapper)

- FXBlurView* (Used in Versus Screen to create scroll animation)

- YLProgressBar* (Stamina Bars)

- FXForms (Used in registration and profile updates)

- ZLSwipeableView (Registration cards)

- CFPressHoldButton (Wrapper for press and hold)

**Notes:** Pods were installed manually, so you won't have to run pod install or use a workspace file. Sue me.

* Source of UI bugs


Test Users
---

Name: Barbara Greenewitz

Email: barbara_ozqnifh_greenewitz@tfbnw.net

Password: test1


Name: David Schrockwitz

Email: david_gkxfydi_schrockwitz@tfbnw.net

Password: test2


Name: Dorothy Chengstein

Email: dorothy_rxwtiqf_chengstein@tfbnw.net

Password: test3


Name: Bob Qinwitz

Email: bob_agvadhg_qinwitz@tfbnw.net

Password: test4


Name: Tom Occhinostein

Email: tom_diotrcd_occhinostein@tfbnw.net

Password: test5


**Notes:** These are test **Facebook** accounts. You will have to sign into them on facebook on your iOS device, or in the simulator, which can be done in the device settings.

It is important to only sign in with these accounts on one device, as that device will be associated with that installation and user, producing an invalid session error if they are signed in on multiple devices.


Known Issues
--- 
- On April 8th Apple released updates to Swift and Xcode that are not backward compatible. This will not run in XCode 6.3 or with Swift 1.2

- There may be some memory gremlins due to swift's whole "your memory is managed for you except it's not" thing. Would be solved by capture lists on closures, and a single Model/API struct.

- PFQuery does not support ordering on .orQueryWithsSubQuery, which is how I'm getting all fights a user is involved in (r). As such, the fights table is not being ordered by recency.

- To update your profile you must rebuild it entirely, as I simply reused the registration form. This would be solved by creating a new form with default values set to the user’s current state.

- Due to the frequency of accelerometer updates, one punch can dismiss multiple cards during registration.

- Couple of things on the main queue that shouldn't be, and a constraint error being thrown by buggy pods

- Blur view on start fight screen is glitchy on the simulator.

- Needs a makeover




