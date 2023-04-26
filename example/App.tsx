import { setCustomDevMenuItems } from 'dev-client-mac-tools';
import { StatusBar } from 'expo-status-bar';
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

export default function App() {
  React.useEffect(() => {
    setCustomDevMenuItems([
      { title: 'Hello', action: () => alert('Hello'), shortcut: 'command-alt-shift-H' },
      { title: 'World', action: () => alert('World') },
      {
        title: 'Sub Menu',
        subitems: [
          { title: 'Submenu A', action: () => alert('Submenu A') },
          { title: 'Submenu B', action: () => alert('Submenu B') },
        ],
      },
    ]);
  }, []);

  return (
    <View style={styles.container}>
      <Text>Open up App.tsx to start working on your app!</Text>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
