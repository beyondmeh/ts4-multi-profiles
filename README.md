# The Sims 4 - Profile Switcher

> Ever wanted to be able to have multiple profiles for Sims 4?

This powershell script allows you to implement multiple profiles in The Sims 4,
allowing multiple saved games to be completely independent of each other.

Use cases:

* Multiple people using one Windows account // - now your siblings won't ruin your game!//
* Mod development and debugging
* Starting fresh without forever erasing your progress
* Implementing backups

## How it Works
A little known feature built into Windows is [symbolic Links](https://docs.microsoft.com/en-us/windows/desktop/fileio/symbolic-links) (symlinks).
They allow you to redirect a folder to a different one, similar to how links on
your desktop work.

This script redirects where //The Sims 4// saves it's data (`Documents/Electronic Arts/The Sims 4`)
to a different folder, creating the ability to have multiple profiles for the game.

## Installation
- Download `switch-profile.ps1` into `Documents/Electronic Arts`
- Within `Documents/Electronic Arts`, rename `The Sims 4` to whatever you want your first profile to be called
- Create more folders for every profile you want:
  - Create empty folders when you want profiles to start as new games
  - Duplicate the old `The Sims 4` folder when you want duplicate profiles with your original saved game

## Running
- Double-click this script to run it, it will ask for admin permissions (needed to create symlinks)
- Behavior:
  - With one profile folder, the script will auto link it so //The Sims 4// will use it
  - Two profile folders, the script will swap between the two profiles each time it is run
  - Three or more profile folders, the script will ask which profile you want to use

## Feedback
I would love your feedback! If you found any of these code useful, please drop me [an email](mailto:timothykeith@gmail.com). For the privacy conscious, feel free to encrypt any messages using my [PGP key](https://gist.githubusercontent.com/keithieopia/434f3575ec1f020d6589a4c01dc0847e/raw/2e0749f2966ff501ee28797a926229c081f7e652/timothykeith.pub.asc):

> 46E6 9F69 90C1 DE8C 9791 88EE 94A4 E2D4 *6B32 AA11*

To import it into your keyring:
```console
$ curl https://gist.githubusercontent.com/keithieopia/434f3575ec1f020d6589a4c01dc0847e/raw/2e0749f2966ff501ee28797a926229c081f7e652/timothykeith.pub.asc | gpg --import -
```

**NOTE:** SKS Public Key Servers (such as pgp.mit.edu) don't support Curve25519 keys yet. In the meantime, consider using [Keybase.io](https://keybase.io/); my username is [timothykeith](https://keybase.io/timothykeith).

### Bug Reports
Submit bug reports via GitHub's [Issue Tracker](https://github.com/keithieopia/ts4-switch-profile/issues).
If you really like me, submit a [pull request](https://github.com/keithieopia/ts4-switch-profile/pulls) instead.


## Author
Copyright &copy; 2019 Timothy Keith, except where otherwise noted.

Licensed under the [MIT license](https://raw.githubusercontent.com/keithieopia/keithieopia.com/master/LICENSE).

*This is free software: you are free to change and redistribute it. There is NO WARRANTY, to the extent permitted by law.*
