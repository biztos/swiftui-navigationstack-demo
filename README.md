# SwiftUI NavigationStack Demo

This is a simple demonstration of SwiftUI's NavigationStack with the following
requirements:

1. Two groups of links, each to its own view
2. Label the groups
3. Second group has another drill-down level made up of the first type
4. ViewModel is updated per view selection

The above list may be expanded in future.

Hope you find it helpful!

__YMMV! E&OE! Maybe (probably) buggy code! Hic sunt dracones!!!__

## Notes

Well it turns out that having two List items in teh NavigationStack looks like
total 💩, which is usually an indication that Apple doesn't like your approach.

So instead we're using a third type which wraps the first two.  Yuck?

