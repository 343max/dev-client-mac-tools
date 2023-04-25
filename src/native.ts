import { requireNativeModule, EventEmitter, Subscription } from 'expo-modules-core';

import { NativeMenuItem } from './nativeTypes';

let MacDevTools = null;
const macDevTools = (): any => {
  if (MacDevTools === null) {
    MacDevTools = requireNativeModule('MacDevTools');
  }
  return MacDevTools;
};

let eventEmitter: EventEmitter | null = null;
const getEventEmitter = (): EventEmitter => {
  if (eventEmitter === null) {
    eventEmitter = new EventEmitter(macDevTools());
  }

  return eventEmitter;
};

export const setNativeDevMenuItems = (menuItems: NativeMenuItem[]) => macDevTools().setCustomDevMenuItems(menuItems);

export const addMenuItemSelectedListener = (listener: (event) => void): Subscription =>
  getEventEmitter().addListener('onMenuItemSelected', listener);
