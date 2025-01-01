/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { enableScreens } from 'react-native-screens';

// Enable screens
enableScreens();

// Screens
import HabitListScreen from './src/screens/HabitListScreen';
import CreateHabitScreen from './src/screens/CreateHabitScreen';

const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <SafeAreaProvider>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen
            name="HabitList"
            component={HabitListScreen}
            options={{ title: 'My Habits' }}
          />
          <Stack.Screen
            name="CreateHabit"
            component={CreateHabitScreen}
            options={{ title: 'Create New Habit' }}
          />
        </Stack.Navigator>
      </NavigationContainer>
    </SafeAreaProvider>
  );
};

export default App;
