# Cocoaplods

A small service to make it easier for [Libraries.io](https://libraries.io) to read data from the [Cocoapods Spec repo](https://github.com/CocoaPods/Specs)

## Essentials

- Provide a REST interface for list of all names of pods (as json)
- Provide a REST interface for list of versions for each pod (as json)
- Update info from Specs repo frequently

## Extras

- Watch https://github.com/CocoaPods/Specs/commits/master.atom for updates
- Push new/updated pods directly into the Libraries sidekiq for processing
- Tell Libraries about removed versions/pods
