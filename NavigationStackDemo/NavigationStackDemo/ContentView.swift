//
//  ContentView.swift
//  NavigationStackDemo
//
//  Created by Kevin Frost on 4/6/24.
//

import SwiftUI

struct Foo: Hashable, Identifiable {
    let id = UUID() // <-- annoying but needed for List() down the way!
    var bar: String
    var baz: String
}

struct Zoo: Hashable, Identifiable {
    let id = UUID()
    var moo: String
    var boo: String
}

// There has got to be a better, idiomatic Swifty way to do this!
struct NavItem: Hashable, Identifiable {
    let id = UUID() // bullshit Swifty crap -- why List not take id: \.self?
    var title: String?
    var foo: Foo?
    var zoo: Zoo?
}

class ViewModel: ObservableObject {
    var foo: Foo?
    var zoo: Zoo?

    // IRL get these from somewhere!
    let fooList = [
        Foo(bar: "bar 1", baz: "baz 1"),
        Foo(bar: "bar 2", baz: "baz 2"),
        Foo(bar: "bar 3", baz: "baz 3"),
    ]

    let zooList = [
        Zoo(moo: "moo 1", boo: "boo 1"),
        Zoo(moo: "moo 2", boo: "boo 2"),
    ]

    var navItems: [NavItem] = []

    init() {
        for foo in self.fooList {
            if foo == self.fooList.first {
                self.navItems.append(NavItem(title: "Foo Group", foo: foo))
            } else {
                self.navItems.append(NavItem(foo: foo))
            }
        }
        for zoo in self.zooList {
            if zoo == self.zooList.first {
                self.navItems.append(NavItem(title: "Zoo Group", zoo: zoo))
            } else {
                self.navItems.append(NavItem(zoo: zoo))
            }
        }
    }

    // This feels egregiously un-Swifty. True?
    func withFoo(foo: Foo) -> ViewModel {
        self.foo = foo
        return self
    }

    func withZoo(zoo: Zoo) -> ViewModel {
        self.zoo = zoo
        return self
    }
}

struct FooView: View {
    var vm: ViewModel
    var body: some View {
        Text("FOO \(self.vm.foo!.bar) \(self.vm.foo!.baz)").font(.largeTitle)
        Spacer()
    }
}

struct ZooView: View {
    var vm: ViewModel
    var body: some View {
        Text("ZOO \(self.vm.zoo!.moo) \(self.vm.zoo!.boo)").font(.largeTitle)
        Spacer()
        ForEach(self.vm.fooList) { foo in
            VStack {
                Text("More on \(foo.bar)").bold()
                Text(foo.baz).font(.largeTitle)

                // NOTE: matching by type with .navigationDestination does NOT
                // work, presumably because the previous invocation caputres al
                // links for type Foo.
                NavigationLink("Details...", destination: ZooFooView(vm: self.vm.withFoo(foo: foo))).bold()

            }.padding().border(.black)
        }
        Spacer()
    }
}

struct ZooFooView: View {
    var vm: ViewModel
    var body: some View {
        Text("ZOO::FOO").font(.largeTitle)
        Text("Foo: \(self.vm.foo!.bar)").font(.title)
        Text("Zoo: \(self.vm.zoo!.moo)").font(.title)
        Spacer()
    }
}

struct ContentView: View {
    @StateObject var vm = ViewModel()
    var body: some View {
        Text("NavigationStack Demo").font(.title)

        NavigationStack {
            List(self.vm.navItems) { nav in
                if let title = nav.title {
                    Text(title).bold()
                }
                if let foo = nav.foo {
                    NavigationLink("Foo \(foo.bar)", value: foo)
                } else if let zoo = nav.zoo {
                    NavigationLink("Zoo \(zoo.moo)", value: zoo)
                }
            }
            .navigationDestination(for: Foo.self) { foo in
                FooView(vm: self.vm.withFoo(foo: foo))
            }
            .navigationDestination(for: Zoo.self) { zoo in
                ZooView(vm: self.vm.withZoo(zoo: zoo))
            }
        }
    }
}

#Preview {
    ContentView()
}
