import { NativeModifierKey } from '../nativeTypes';
import {
  toNativeModifierKey,
  toNativeKeyCombo,
  idGenerator,
  toNativeMenuItem,
  toNativeMenuItems,
  toMenuItemCallbackList,
} from '../transform';
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

  test('toNativeMenuItems', () => {
    const menuItems: MenuItem[] = [
      { title: 'Hello', action: () => {} },
      { title: 'World', action: () => {} },
    ];
    const nativeMenuItems = toNativeMenuItems(menuItems, idGenerator());
    expect(nativeMenuItems).toEqual([
      {
        title: 'Hello',
        id: 'id1',
        enabled: true,
      },
      {
        title: 'World',
        id: 'id2',
        enabled: true,
      },
    ]);
  });

  test('toMenuItemCallbackList', () => {
    const fakeAction = (id: string) => `fn(${id})` as unknown as () => void;
    const menuItems: MenuItem[] = [
      { title: 'Hello', action: fakeAction('Hello') },
      { title: 'World', action: fakeAction('World') },
    ];
    const nativeMenuItems = toMenuItemCallbackList(menuItems, idGenerator());
    expect(nativeMenuItems).toEqual({ id1: fakeAction('Hello'), id2: fakeAction('World') });
  });

  test('toMenuItemCallbackList with subItems', () => {
    const fakeAction = (id: string) => `fn(${id})` as unknown as () => void;
    const menuItems: MenuItem[] = [
      { title: 'Hello', action: fakeAction('Hello') },
      { title: 'World', action: fakeAction('World') },
      {
        title: 'submenu',
        subitems: [
          { title: 'sub1', action: fakeAction('sub1') },
          { title: 'sub2', action: fakeAction('sub2') },
        ],
      },
    ];
    const nativeMenuItems = toMenuItemCallbackList(menuItems, idGenerator());
    expect(nativeMenuItems).toEqual({
      id1: fakeAction('Hello'),
      id2: fakeAction('World'),
      id3: fakeAction('sub1'),
      id4: fakeAction('sub2'),
    });
  });
});
