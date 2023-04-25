import { NativeModifierKey } from '../nativeTypes';
import { toNativeModifierKey, toNativeKeyCombo, idGenerator, toNativeMenuItem } from '../transform';
import { MenuItem } from '../types';

describe('transform', () => {
  test('toNativeModifierKey', () => {
    expect(toNativeModifierKey('command')).toBe(NativeModifierKey.Command);
    expect(toNativeModifierKey('alt')).toBe(NativeModifierKey.Option);
    expect(toNativeModifierKey('ctrl')).toBe(NativeModifierKey.Control);
    expect(toNativeModifierKey('shift')).toBe(NativeModifierKey.Shift);
  });

  test('toNativeKeyCombo', () => {
    expect(toNativeKeyCombo('command-A')).toEqual({ modifiers: [NativeModifierKey.Command], key: 'A' });
    expect(toNativeKeyCombo('command-shift-P')).toEqual({
      modifiers: [NativeModifierKey.Command, NativeModifierKey.Shift],
      key: 'P',
    });
  });

  test('idGenerator', () => {
    const next = idGenerator();
    expect(next()).toBe('id1');
    expect(next()).toBe('id2');
    expect(next()).toBe('id3');
  });

  test('toNativeMenuItem', () => {
    const menuItem: MenuItem = { title: 'Hello', shortcut: 'command-A', action: () => {} };
    const nativeMenuItem = toNativeMenuItem(menuItem, () => 'id1');
    expect(nativeMenuItem).toEqual({
      title: 'Hello',
      shortcut: { modifiers: [NativeModifierKey.Command], key: 'A' },
      id: 'id1',
      enabled: true,
    });
  });

  test('toNativeMenuItem with subItems', () => {
    const menuItemWithSubitems: MenuItem = {
      title: 'With Subitems',
      subitems: [
        { title: 'Sub Menu 1', action: () => {} },
        { title: 'Sub Menu 2', action: () => {} },
      ],
    };
    const nativeMenuItem = toNativeMenuItem(menuItemWithSubitems, idGenerator());
    expect(nativeMenuItem).toEqual({
      title: 'With Subitems',
      id: 'id1',
      enabled: true,
      subitems: [
        { title: 'Sub Menu 1', id: 'id2', enabled: true },
        { title: 'Sub Menu 2', id: 'id3', enabled: true },
      ],
    });
  });
});
