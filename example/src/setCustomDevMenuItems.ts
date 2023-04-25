import { setCustomDevMenuItems } from 'dev-client-mac-tools';

export const customMenuTrigger = () => {
  console.log('start');
  setTimeout(() => {
    setCustomDevMenuItems([
      { title: 'Hello', action: () => console.log('Hello'), shortcut: 'command-alt-H' },
      { title: 'World', action: () => console.log('World') },
    ]);
  }, 100);
  console.log('done');
};
