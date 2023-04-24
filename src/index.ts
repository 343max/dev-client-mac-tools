import MacDevTools from './MacDevTools';

enum NativeModifierKey {
  Command = 'Command',
  Shift = 'Shift',
  Option = 'Option',
  Control = 'Control',
}

type NativeKeyCombo = { modifiers: NativeModifierKey[]; key: string };

type NativeMenuItem = {
  id: string;
  title: string;
  enabled: boolean;
  shortcut?: NativeKeyCombo;
  subitems?: NativeMenuItem[];
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
  MacDevTools.setCustomDevMenuItems(items);
};
