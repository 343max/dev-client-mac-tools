export enum NativeModifierKey {
  Command = 'Command',
  Shift = 'Shift',
  Option = 'Option',
  Control = 'Control',
}

export type NativeKeyCombo = { modifiers: NativeModifierKey[]; key: string };

export type NativeMenuItem = {
  title: string;
  enabled: boolean;
  actionId?: string;
  shortcut?: NativeKeyCombo;
  subitems?: NativeMenuItem[];
};
