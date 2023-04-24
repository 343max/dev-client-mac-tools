const modifiersKeys = ['command', 'alt', 'shift', 'ctrl'] as const;
export type ModifierKey = (typeof modifiersKeys)[number];

const Keys = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
] as const;
export type Key = (typeof Keys)[number];

export type KeyCombo =
  | `${ModifierKey}-${Key}`
  | `${ModifierKey}-${ModifierKey}-${Key}`
  | `${ModifierKey}-${ModifierKey}-${ModifierKey}-${Key}`;

type MenuItem =
  | {
      title: string;
      shortcut?: KeyCombo;
    } & (
      | {
          action: () => void;
        }
      | { subItems: MenuItem[] }
    );

export const extraEntries: MenuItem[] = [
  { title: 'Open Shake Menu', shortcut: 'command-shift-z', action: () => console.log('hello!') },
];

export const setAdditionalDevMenuItems = (items: MenuItem[]) => {};

setAdditionalDevMenuItems([
  { title: 'Open Shake Menu', shortcut: 'command-shift-z', action: () => console.log('hello!') },
]);
