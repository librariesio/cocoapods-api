# CocoaPods API

A small service to make it easier for [Libraries.io](https://libraries.io) to read data from the [CocoaPods Spec repo](https://github.com/CocoaPods/Specs)

## Essentials

- Provide a REST interface for list of all names of pods (as json)
- Provide a REST interface for list of versions for each pod (as json)
- Update info from Specs repo frequently

## Extras

- Watch https://github.com/CocoaPods/Specs/commits/master.atom for updates
- RSS feed of new/updated pods for https://github.com/librariesio/watcher to track
- Tell Libraries about removed versions/pods
