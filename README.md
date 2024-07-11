# Run your iOS expo dev client on your Mac 

With [testflight-dev-deploy](https://github.com/343max/testflight-dev-deploy) developers can run expo dev client apps on their phones but also on their Macs. This makes it possible to develop expo apps on an Mac that hasn't installed Xcode at all: all you need are your javascript dev tools, an editor and the dev client app downloaded from TestFlight.

While this works it's not perfect: reloading the app, connecting to the debugger or opening the dev menu are possible but complicated.

`mac-dev-tools` fixes these issues. It provides a Dev menu on your Mac with some handy tools:

# Commands

Toggle between dark and light mode
<img src="/images/toggle-dark-mode.gif" width="100%">

Reload the app
<img src="/images/reload.gif" width="100%">

Show the Expo Dev Menu
<img src="/images/toggle-expo-menu.gif" width="100%">

Resize to preview common iPhone sizes
<img src="/images/resize.gif" width="100%">

# Custom Commands

<img src="/images/custom-commands.gif" width="100%">

To add your own commands to the dev menu you need to call the `setCustomDevMenuItems` function. You should wrap the call in a `useEffect` hook to make sure it doesn't run on every render.

You can easily add shortcut keys or submenus.

Here is an example where it's wrapped in its own hook:

```ts
import { setCustomDevMenuItems } from "dev-client-mac-tools";

const useGenerateDevMenu = () => {
  React.useEffect(() => {
    setCustomDevMenuItems([
      {
        title: "Say Hello",
        shortcut: "command-ctrl-alt-S",
        action: () => {
          console.log("Hello!");
        },
      },
      {
        title: "Menu with submenus",
        subitems: [
          {
            title: "Entry 1",
            action: () => {},
          },
          {
            title: "Entry 2",
            action: () => {},
          },
        ],
      },
    ]);
  }, []);
};
```

In production builds this javascript code is still included but it doesn't do anything.

# Adding dev-client-mac-tools to your expo project

In order to use this plugin you need to configure your app in a way that allows in to be signed to run on your Mac first. I highly recommend using [testflight-dev-deploy](https://github.com/343max/testflight-dev-deploy) to do this is the easiest and most future proof way.

Next add `dev-client-mac-tools` using the expo cli.

```bash
expo install dev-client-mac-tools
```

The code injects itself into the debug build of the app so there is nothing you need to do. Just rebuild the app and run it on your Mac and you should see the menu.

By default the menu is only included in debug builds. In production builds the native code will automatically be compiled out.

(If you want to have tighter control when the menu is included and when not you can control it using the `KDR_ENABLED` preprocessor macro.)

# Installing the Dev Client App from TestFlight on your developers Mac

<img src="/images/install.gif" width="100%">

Installation of the Dev Client App takes seconds and is extremly simple. No Xcode install, no build, no Simulator runtime download.

# Updating the Dev Client App from TestFlight

<img src="/images/update.gif" width="100%">

Updating the Dev Client App is just one click or can even run automatically in the background.
