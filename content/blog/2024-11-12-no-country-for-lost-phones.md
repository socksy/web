+++
title = "No Country for Lost Phones"
date = "2024-11-12"
+++

# No Country for Lost Phones

I spend a lot of my time lately worrying. One thing I worry about losing access to my entire existence, especially when on holiday.
<!-- more -->

As the years of my life have flown by, the more entwined my entire being has been with my digital life. Bank, messaging, contacts, job, and even my ID are intrinsically linked to my online presence. And I don't want to even think about how much of a disaster it would be for me to lose access to my email.

I believe, of course, that I'm no outlier in this regard — smartphones especially were probably an inflection point for our collective enmeshment.

As our usage has grown, so have our security measures. Sure, we all use https nowadays, but we also tend to use stronger passwords (after being forced to by major providers). We have 2-factor auth enabled, and we've been gradually moving away from hackable SMS confirmations over to TOTP tokens on phones and password managers.

### Holiday
A few years ago, when I would travel to another country, I would print out my t plane tickets twice. Once for my pocket, and another emergency one at the back of my bag, just in case. If I had difficult to get to accommodation, I'd print off the google maps (or mapquest) step-by-step directions.[^photocopy]

[^photocopy]: I'd also photocopy my passport and hide some cash in my shoe, but I guess that's more of a me-being-paranoid thing

Nowadays, I would just use my phone. Flight tickets? Phone app. Itinerary? Phone notes. Hotel booking? Phone email. Directions? Bing Maps. International currency? Phone NFC payments.

### Paris Panic
Put out by panic in Paris, you’re perilously phoneless.[^how] Could you consider that this Kyoto crisis couldn’t cut you off completely? Or are you doomed to roam alone in Rome as your new Chrome-free home?

[^how]: Sitting on the netting outside of Kater Blau, high as a kite, you shuffle closer to a particularly cute someone, the entire contents of your jean pockets slipping out and through the net into the Spree river below

### Always have an out
Yeah, you can probably work it out eventually. If you lost your ID, you’d make it to your country’s embassy to get an overly expensive spare one. Perhaps with that you can recover your email at an internet café (lol), which you then use to reset your Goopple account on a brand new $1000 phone you just bought from a shady corner shop.

However, it is my opinion that life is easier if you have anticipated worse case scenarios, and have taken preemptive steps to reduce the repercussions.

In this case, you should have decided in advance a way that you can recover as much of your digital life as needed from a clean device. In my opinion, the most practical way to do this is to be able to access your passwords from the cloud. Probably most paid-for password managers have some way to do this. I’m not sure, I don’t use them. I wouldn’t be surprised though if it’s possible to completely lock yourself out of them.

Personally, I use KeepassXC, which I sync with all my devices using Syncthing (with staggered versioning turned on).

Some of those devices are in the cloud — VPSes for which I have SSH access to.[^password ssh] Then I can usually set up syncthing (port forwarding 8384) to sync to a local device, making sure my password is long and with much entropy.

[^password ssh]: For this to work, at least one of the accounts has to buck best security practices and have it possible to login with a password, unless you're particularly talented at remembering SSH keys by heart. Make sure to fail2ban and to not use port 22

As an aside, don't use passphrases. [They're a bad idea](https://arstechnica.com/information-technology/2013/05/how-crackers-make-minced-meat-out-of-your-passwords/#page-3). But make sure you choose something that's both high entropy and also memorable. Perhaps take the first letter of every word in a paragraph you can remember by heart.

Finally, I make sure to store my TOTP tokens on the cloud too. After a few painful experiences with resetting phones with Google Authenticator, I think the pain of losing a 2FA token when you really need it is much higher than the possibility that someone gets access to that too. If you really worry, put it in a different password database than the password itself. Congrats, it's two factors now.

### Conclusion
Obviously the average jane isn't going to be doing stuff the way I describe here. It's stupidly nerdy, and not necessarily in a good way. I should probably rethink it.

However, the most important take away — have an out. At least I know what I can do in the situation where I lose access to all my devices. Make sure you do too, whatever that looks like for you.
