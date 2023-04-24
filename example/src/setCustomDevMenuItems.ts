import * as MacDevTools from 'dev-client-mac-tools';

export const customMenuTrigger = () => {
  console.log('start');
  MacDevTools.setCustomDevMenuItems();
  console.log('done');
};
