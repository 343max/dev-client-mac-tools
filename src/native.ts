import { requireNativeModule, EventEmitter, Subscription } from 'expo-modules-core';

import { NativeMenuItem } from './nativeTypes';

const MacDevTools = requireNativeModule('MacDevTools');

const eventEmitter = new EventEmitter(MacDevTools);

export const setNativeDevMenuItems = (menuItems: NativeMenuItem[]) => MacDevTools.setCustomDevMenuItems(menuItems);

type MenuItemSelectedEvent = { menuItemId: string };

export const addMenuItemSelectedListener = (listener: (event: MenuItemSelectedEvent) => void): Subscription =>
  eventEmitter.addListener('onMenuItemSelected', listener);
