# -*- coding: utf-8 -*-
"""
Created on Sun Sep 22 16:55:01 2019

@author: Charollina
"""

import os

import numpy as np
import pandas as pd
from keras import Sequential
from keras.layers import Conv2D, MaxPooling2D, Dense, Dropout, Flatten, BatchNormalization, Activation
from keras.callbacks import ModelCheckpoint, EarlyStopping, TensorBoard
from keras.preprocessing import image

# ścieżka do danych zbioru treningowego
train_labels = "C:\\Users\\Charollina\\Dropbox\\DataScience_InfoShare\\datasets\\dresses\\train\\labels.txt"
val_labels = "C:\\Users\\Charollina\\Dropbox\\DataScience_InfoShare\\datasets\\dresses\\val\\labels.txt"
test_labels=train_labels = "C:\\Users\\Charollina\\Dropbox\\DataScience_InfoShare\\datasets\\dresses\\test\\labels.txt"



def get_generator(filename, number=None):
    # załadowanie pliku txt do ramki pandas
    df = pd.read_csv(filename, delimiter=' ', names=["path", 'beige', 'black', 'blue', 'brown', 'gray', 'green', 'multicolor', 'orange', 'pink', 'red', 'violet', 'white', 'yellow', 'transaprent'], dtype="str")
    # stworzenie generatora
    gen = image.ImageDataGenerator()
    # folder z danymi, do którego będą doklejane ścieżki z odpowiedniej kolumny
    directory = os.path.dirname(filename)
    # stworzenie iteratora po danych z zadanymi opcjami
    return gen.flow_from_dataframe(df, directory, "path", class_mode="other", y_col=['beige', 'black', 'blue', 'brown', 'gray', 'green', 'multicolor', 'orange', 'pink', 'red', 'violet', 'white', 'yellow', 'transaprent'], target_size=(500, 500), batch_size=10)




def create_model(gen):
    # architektura sekwencyjna
    model = Sequential()
    # warstwa konwolucyjna, 16 filtrów 3x3, aktywacja relu, pierwsza warstwa w sieci, więc musi mieć podany rozmiar wejścia
    model.add(Conv2D(16, (3, 3), activation='relu', input_shape=(500, 500, 3)))
    # warstwa konwolucyjna, 16 filtrów 3x3, aktywacja relu
    model.add(Conv2D(16, (3, 3), activation='relu'))
    # warstawa max pooling o rozmiarze 2x2
    model.add(MaxPooling2D(pool_size=(2, 2)))

    # warstwa konwolucyjna, 32 filtry 3x3, aktywacja relu
    model.add(Conv2D(32, (3, 3), activation='relu'))
    # warstwa konwolucyjna, 32 filtry 3x3, aktywacja relu
    model.add(Conv2D(32, (3, 3), activation='relu'))
    # warstawa max pooling o rozmiarze 2x2
    model.add(MaxPooling2D(pool_size=(2, 2)))

    # warstwa spłaszczająca
    model.add(Flatten())
    # warstwa dense z 128 neuronami, aktywacja relu
    model.add(Dense(52, activation='relu'))
    # warstwa dense z 52 neuronami - tyle ile jest końcowo klas, aktywacja softmax - bo chcemy mieć rozkład prawdopodobieństwa
    model.add(Dense(14, activation='softmax'))

    # podstawowy optymalizator sgd, dobry loss do klasyfikacji 1 z k
    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model

def CNN2_norm(gen):
    model = Sequential()
    # Must define the input shape in the first layer of the neural network
    model.add(Conv2D(filters=64, kernel_size=2, padding='same', input_shape=(500, 500,3)))
    model.add(BatchNormalization())
    model.add(Activation("relu"))
    model.add(MaxPooling2D(pool_size=2))
    model.add(Dropout(0.3))
    model.add(Conv2D(filters=32, kernel_size=2, padding='same'))
    model.add(BatchNormalization())
    model.add(Activation("relu"))
    model.add(MaxPooling2D(pool_size=2))
    model.add(Dropout(0.3))
    model.add(Flatten())
    model.add(Dense(256))
    model.add(BatchNormalization())
    model.add(Activation("relu"))
    model.add(Dropout(0.5))
    model.add(Dense(14, activation='softmax'))

    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model

def get_callbacks(name):
    # pusta lista na callbacki
    callbacks = []
    name=name+'.hdf5'

    # zapisywanie wag do pliku weights.hdf5 pod warunkiem że val_loss spadał, zapisuje tylko najlepszy model
    mc = ModelCheckpoint(name, monitor="val_loss", save_best_only=True, verbose=1)
    # przerywa trening jeśli przez 2 kolejne epoki val_loss się nie poprawi
    es = EarlyStopping(monitor="val_loss", patience=5, verbose=1)
    # tensorboard - narzędzie do oglądania wyników treningu
    tb = TensorBoard()

    # dodanie callbacków do listy
    callbacks.append(mc)
    callbacks.append(es)
    callbacks.append(tb)

    return callbacks

def main():
    epochs=1
    
    train_gen = get_generator(train_labels)
    val_gen = get_generator(val_labels)
    test_gen = get_generator(test_labels)
    # stwórz model
    model = create_model(train_gen)
    model2=CNN2_norm(train_gen)
    # trening :)
    model.fit_generator(train_gen, epochs=epochs, validation_data=val_gen)
    model2.fit_generator(train_gen, epochs=epochs, validation_data=val_gen)
    
    score = model.evaluate_generator(test_gen, verbose=0)
    score = ['%.3f' % elem for elem in score]
    score2 = model2.evaluate_generator(test_gen, verbose=0)
    score2 = ['%.3f' % elem for elem in score2]
    
    print('Test loss: Zajęcia  {0}, Medium norm {1}'.format(score[0], score2[0]))
    print('Test accuracy: Zajęcia {0}, Medium norm {1}'.format(score[1], score2[1]))
    


if __name__ == '__main__':
    main()

