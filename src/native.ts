import { requireNativeModule } from 'expo-modules-core';

import { NativeMenuItem, NativeModifierKey } from './nativeTypes';

let MacDevTools = null;

const macDevTools = (): any => {
  if (MacDevTools === null) {
    MacDevTools = requireNativeModule('MacDevTools');
  }
  return MacDevTools;
};

export const setCustomDevMenuItems = () => {
  const items: NativeMenuItem[] = [
    {
      id: 'a',
      title: 'Hello',
      enabled: false,
      shortcut: { modifiers: [NativeModifierKey.Command, NativeModifierKey.Shift], key: 'H' },
      subitems: [],
    },
    {
      id: 'b',
      title: 'World',
      enabled: true,
      shortcut: { modifiers: [NativeModifierKey.Command, NativeModifierKey.Shift], key: 'W' },
    },
  ];
  macDevTools().setCustomDevMenuItems(items);
};
