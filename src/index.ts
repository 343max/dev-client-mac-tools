import { Subscription } from 'expo-modules-core';

import { addMenuItemSelectedListener, setNativeDevMenuItems, devMenuEnabled } from './native';
import { idGenerator, toMenuItemCallbackList, toNativeMenuItems } from './transform';
import { MenuItem } from './types';

let subscription: Subscription | null;

export const setCustomDevMenuItems = (items: MenuItem[]) => {
  if (!devMenuEnabled) {
    return;
  }

  const callbackList = toMenuItemCallbackList(items, idGenerator());
  const nativeMenuItems = toNativeMenuItems(items, idGenerator());

  if (subscription) {
    subscription.remove();
    subscription = null;
  }

  if (Object.keys(callbackList).length > 0) {
    subscription = addMenuItemSelectedListener((event) => {
      const callback = callbackList[event.menuItemId];
      if (!callback) {
        throw new Error(`No callback found for menu item id: ${event.menuItemId}`);
      }
      callback();
    });
  }

  setNativeDevMenuItems(nativeMenuItems);
};
