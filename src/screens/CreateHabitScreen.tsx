import React, { useState } from 'react';
import { View, StyleSheet } from 'react-native';
import { TextInput, Button } from 'react-native-paper';

const CreateHabitScreen = () => {
    const [habitName, setHabitName] = useState('');
    const [description, setDescription] = useState('');

    const handleCreate = () => {
        // We'll implement habit creation logic later
    };

    return (
        <View style={styles.container}>
            <TextInput
                label="Habit Name"
                value={habitName}
                onChangeText={setHabitName}
                style={styles.input}
            />
            <TextInput
                label="Description"
                value={description}
                onChangeText={setDescription}
                multiline
                style={styles.input}
            />
            <Button mode="contained" onPress={handleCreate} style={styles.button}>
                Create Habit
            </Button>
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        padding: 16,
        backgroundColor: '#fff',
    },
    input: {
        marginBottom: 16,
    },
    button: {
        marginTop: 8,
    },
});

export default CreateHabitScreen; 