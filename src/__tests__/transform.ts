import { toNativeModifierKey, toNativeKeyCombo } from '../transform';
import { NativeModifierKey } from '../nativeTypes';
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
});
