# CloudKit Tutorial

- This tutorial will teach you the most basic components of Apple's ***CloudKit***.
- We are going to build a simple photo app called **Nutstagram** that allows you to upload photos from Camera and store them in iCloud.
- Prerequisit: `UITableView` (We won't go over too much details on how UITableView works, you can check out our previous tutorials on it if needed)

---

### Starting a New Project

1. **Create a new Xcode project** by clicking on ***Create a new Xcode project*** in the Xcode Lunch windows
2. Select ***Single View Application***
3. ![Screen Shot 2016-10-20 at 3.18.58 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 3.18.58 PM.png)Give the project a name, and click on ***Next***.
4. Click on ***Create***.

---

### CloudKit Overview

- "Why in the world would you ever want to use CloudKit?"

  - It’s simple. Everything is handled by Apple. You don’t have to download any library and the users don’t need to go through the sign-up/sign-in headaches.
  - It’s trustworthy (maybe?). Privacy and security are, again, handled by Apple.
  - It’s cost-free, until you reach a certain amount of data. Apple offers a good amount of storage for free, which means it's pretty useful for small apps without a lot of traffic.

- "Then why in the world would you not use CloudKit?"

  - Using iCloud means your users need an iCloud account and have to be signed in on  their devices to use your app, and that sucks for a lot of people!
  - It only works on Apple platforms, so goodbye Android integration.
  - It’s probably still not as good as AWS or your good-old homemade MySQL server.

- **CloudKit Structure**

  - iCloud is devided into several containners, there are 7 of them:
    - `CKContainer`: a sandbox that allows an application to do whatever it wants inside this box; it's the most outer layer of our structure.
    - `CKDatabase`: include a private and a public database; the pirvate database should be used to store user information and other sensitive data; in this toturial, we're only going to use the public database.
    - `CKRecord`: these are like objects or templates that allow you store different types of information under a single piece of data using a key-value pair system.
      - For now, you can save `NSString`, `NSNumber`, `NSData`, `NSDate`, `CLLocation`,`CKReference`, and `CKAsset` in a CKRecord.
    - `CKRecordZone`: records are organized and stored in these zones; you can have both default and cutom zones.
    - `CKRecordIdentifier`: these are unique labels for records.

- **Entitlement**

  - Unfortunaely, you have to be enrolled in Apple's Developer Program in order to use CloudKit.
  - But that's okay. If you don't have a developer's account, just sign in using these:
    - ***username: sstevenshang@gmail.com***
    - ***password: CloudKitDemo2016***
  - Note: this step is very important, you must have a valid developer account to continue development
  - Note: the iCloud container's name should be `iCloud.come.<your domain>.CloudKitDemo`
  - Enable CloudKit by clicking on the project, under ***Capabilities***, turn on ***iCloud*** and check out ***CloudKit*** under ***Services***:  ![Screen Shot 2016-10-20 at 3.48.30 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 3.48.30 PM.png)It should look like this.
  - Now you're ready to dive into CloudKit

  ---

  ### CloudKit Dashboard

  - Go to https://icloud.developer.apple.com/dashboard/ and log in using a valid developer's account (again, use *sstevenshang@gamil.com* is you don't have one)
  - As you can see, there are four sections:
    - **Schema**: this is where we store our ***Record Type***
    - Public Data: the database for public data
    - Private Data: the database for private data
    - Admin: this provides the ability to configure fashboard permissions
  - In this tutorial, we will create one Record Type called ***Post***

  1. Go to ***Record Types*** under ***Schema***
  2. Click on the little ***Plus Sign***, name it "UserPost", and create two fields:
     1. "Date" with field type String
     2. "Image" with field type Image
  3. It should look something like this:  ![Screen Shot 2016-10-20 at 3.46.39 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 3.46.39 PM.png)Once this is done, you now have a template for the basic data structure of our app.

  ---

  ### Basic UI Setup 

  - Before we start, let's first hook together some UI for the display of photos and a button for uploading photos! 
  - Drag ***Navigation Bar*** and insert it on the top of our ***View Controller***, and double click to name it *"Today's Post*".![Screen Shot 2016-10-20 at 3.57.10 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 3.57.10 PM.png) 
  - Add the following three constraints on our ***Navegation Bar***![Screen Shot 2016-10-20 at 4.00.17 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.00.17 PM.png)
  - Now add two ***Bar Button Item*** onto each side of our ***Navigation Bar*** like this: ![Screen Shot 2016-10-20 at 4.02.14 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.02.14 PM.png)
  -  Click on the right ***Button*** and under the *attribute inspector*, select ***"Add"*** under ***System Item***. Similarly, do the same thing for the left ***Button*** and select ***"Refresh"*** under ***System Item***.  ![Screen Shot 2016-10-20 at 4.06.52 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.06.52 PM.png)The result should look like something like this.
  - Now insert a ***Table View***: ![Screen Shot 2016-10-20 at 4.08.21 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.08.21 PM.png)and create the following constrains: ![Screen Shot 2016-10-20 at 4.09.25 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.09.25 PM.png)
  - Update your frames and it should look like this:  ![Screen Shot 2016-10-20 at 4.10.52 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.10.52 PM.png)
  - Now, insert a ***Table View Cell*** inside our ***Table View***, name it *"Post"*
  - You can make the ***Post*** cell a little bit higher so it's easier for us to arrange stuffs inside it (Don't worry, we're going to resize the row height in code):  ![Screen Shot 2016-10-20 at 4.12.36 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.12.36 PM.png)
  - Now insert a ***ImageView*** and a ***Label***:  ![Screen Shot 2016-10-20 at 4.15.07 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.15.07 PM.png)
  - Add the following constraints on ***Image view***: ![Screen Shot 2016-10-20 at 4.16.13 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.16.13 PM.png)Note that we want the constraint ***Aspect Ratio*** because we want the photo to be a squere. However right now, the ratio if off, and we need to go to the ***size inspector*** to change it!  ![Screen Shot 2016-10-20 at 4.19.26 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.19.26 PM.png)Update the ***multiplier*** to *"1:1"*.
  - Add the following constraint on **Label**:  ![Screen Shot 2016-10-20 at 4.22.18 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.22.18 PM.png)
  - Okay, we have our basic UIs ready, now let's go create a new ***CocoaTouch Class*** file and name it ***PostTableViewCell*** under the subclass ***UITableViewCell***: ![Screen Shot 2016-10-20 at 4.26.09 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.26.09 PM.png)
  - Next, go to our ***Main.storyboard***, under ***Identity inspector***, set Class to ***"PostTableViewCell"***
  - Create the following IBOutlet in ***PostTableViewCell.swift*** by the name *"postImageView"* and *"dateLabel"*: ![Screen Shot 2016-10-20 at 4.29.30 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.29.30 PM.png)(to create IBOutlet, control drag from the view to the class in the Assisstant Editor)
  - Go to ***Main.storyboard*** again, in the left side panel, control drag ***Table View*** to ***View Controller*** twice and check on ***dataSource*** and ***delegate***:![Screen Shot 2016-10-20 at 4.33.08 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.33.08 PM.png)
  - One last thing, create an IBOutlet for ***Table View*** in our ***ViewController.swift*** using the name *"tableView"*:  ![Screen Shot 2016-10-20 at 4.35.47 PM](/CloudKitDemo/Images/Screen Shot 2016-10-20 at 4.35.47 PM.png)
  - Good, now we are ready to start coding!







