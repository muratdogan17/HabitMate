import React from 'react';
import { View, StyleSheet, FlatList } from 'react-native';
import { FAB } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';

type RootStackParamList = {
    HabitList: undefined;
    CreateHabit: undefined;
};

type NavigationProp = NativeStackNavigationProp<RootStackParamList, 'HabitList'>;

const HabitListScreen = () => {
    const navigation = useNavigation<NavigationProp>();
    const habits: Array<{ id: string }> = []; // Add basic typing for now

    return (
        <View style={styles.container}>
            <FlatList
                data={habits}
                keyExtractor={(item) => item.id}
                renderItem={({ item: _ }) => (
                    // We'll implement the habit item component later
                    <View />
                )}
            />
            <FAB
                style={styles.fab}
                icon="plus"
                onPress={() => navigation.navigate('CreateHabit')}
            />
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    fab: {
        position: 'absolute',
        margin: 16,
        right: 0,
        bottom: 0,
    },
});

export default HabitListScreen; 