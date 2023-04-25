import { Subscription } from 'expo-modules-core';

import { addMenuItemSelectedListener, setNativeDevMenuItems } from './native';
import { idGenerator, toMenuItemCallbackList, toNativeMenuItems } from './transform';
import { MenuItem } from './types';

let subscription: Subscription | null;

export const setCustomDevMenuItems = (items: MenuItem[]) => {
  const callbackList = toMenuItemCallbackList(items, idGenerator());
  const nativeMenuItems = toNativeMenuItems(items, idGenerator());

  if (subscription) {
    subscription.remove();
    subscription = null;
  }

  if (Object.keys(callbackList).length > 0) {
    subscription = addMenuItemSelectedListener((event) => {
      console.log(event);
      const callback = callbackList[event.id];
      if (callback) {
        callback();
      }
    });
  }

  setNativeDevMenuItems(nativeMenuItems);
};
