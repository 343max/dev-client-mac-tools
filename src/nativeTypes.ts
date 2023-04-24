export enum NativeModifierKey {
  Command = 'Command',
  Shift = 'Shift',
  Option = 'Option',
  Control = 'Control',
}

export type NativeKeyCombo = { modifiers: NativeModifierKey[]; key: string };

export type NativeMenuItem = {
  id: string;
  title: string;
  enabled: boolean;
  shortcut?: NativeKeyCombo;
  subitems?: NativeMenuItem[];
};
