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
  const nativeMenu: NativeMenuItem = { title: menuItem.title, enabled: true };

  if ('subitems' in menuItem) {
    nativeMenu.subitems = menuItem.subitems.map((subitem) => toNativeMenuItem(subitem, nextId));
    return nativeMenu;
  }

  if (menuItem.shortcut) {
    nativeMenu.shortcut = toNativeKeyCombo(menuItem.shortcut);
  }

  nativeMenu.actionId = nextId();

  return nativeMenu;
};

export const toNativeMenuItems = (menuItems: MenuItem[], nextId: NextIdFn): NativeMenuItem[] =>
  menuItems.map((menuItem) => toNativeMenuItem(menuItem, nextId));

export const toMenuItemCallbackList = (menuItems: MenuItem[], nextId: NextIdFn): Record<string, () => void> =>
  menuItems.reduce((acc, menuItem) => {
    if ('action' in menuItem) {
      return { ...acc, [nextId()]: menuItem.action };
    } else {
      return { ...acc, ...toMenuItemCallbackList(menuItem.subitems, nextId) };
    }
  }, {});
