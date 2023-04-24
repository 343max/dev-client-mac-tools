import { setAdditionalDevMenuItems } from 'dev-client-mac-tools';

export const customMenuTrigger = () => {
  console.log('start');
  setAdditionalDevMenuItems([
    { title: 'Hello', action: () => console.log('Hello'), shortcut: 'command-alt-H' },
    { title: 'World', action: () => console.log('World') },
  ]);
  console.log('done');
};
