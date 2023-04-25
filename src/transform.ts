import { NativeKeyCombo, NativeMenuItem, NativeModifierKey } from './nativeTypes';
import { KeyCombo, MenuItem, ModifierKey } from './types';

export const toNativeModifierKey = (modifierKey: ModifierKey): NativeModifierKey => {
  switch (modifierKey) {
    case 'command':
      return NativeModifierKey.Command;
    case 'alt':
      return NativeModifierKey.Option;
    case 'shift':
      return NativeModifierKey.Shift;
    case 'ctrl':
      return NativeModifierKey.Control;
  }
};

export const toNativeKeyCombo = (keyCombo: KeyCombo): NativeKeyCombo => {
  const [key, ...modifierKeys] = keyCombo.split('-').reverse();
  return { key, modifiers: (modifierKeys as ModifierKey[]).map(toNativeModifierKey).sort() };
};

export type NextIdFn = () => string;

export const idGenerator = (): NextIdFn => {
  let i = 1;
  return () => `id${i++}`;
};

export const toNativeMenuItem = (menuItem: MenuItem, nextId: NextIdFn): NativeMenuItem => {
  const nativeMenu: NativeMenuItem = { title: menuItem.title, id: nextId(), enabled: true };

  if (menuItem.shortcut) {
    nativeMenu.shortcut = toNativeKeyCombo(menuItem.shortcut);
  }

  if ('subitems' in menuItem) {
    nativeMenu.subitems = menuItem.subitems.map((subitem) => toNativeMenuItem(subitem, nextId));
  }

  return nativeMenu;
};
