import { NativeKeyCombo, NativeModifierKey } from './nativeTypes';
import { KeyCombo, ModifierKey } from './types';

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
