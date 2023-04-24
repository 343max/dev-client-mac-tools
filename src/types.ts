const modifiersKeys = ['command', 'alt', 'shift', 'ctrl'] as const;
export type ModifierKey = (typeof modifiersKeys)[number];

const Keys = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
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

export type MenuItem =
  | {
      title: string;
      shortcut?: KeyCombo;
    } & (
      | {
          action: () => void;
        }
      | { subItems: MenuItem[] }
    );
