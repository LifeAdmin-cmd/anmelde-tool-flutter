# DPV Anmelde-Tool App - Documentation
Dokumentation der APIs und Modulstruktur die für die APP benötigt werden.

## Endpoint: GET und POST `/fahrten/:fahrtenId/anmeldung`

### Overview

Der API Endpoint dient dazu die Daten einer bereits erstellten Anmeldung abzurufen und eine neue Anmeldung hinzuzufügen.

### Response / Request Format

Die API responded mit einem JSON mit einem key "pageData", welcher ein weiters Object enthält. Dieses Object enthält die Daten der einzelenen Module die für die Anmeldung verwendet wurden. Die Struktur muss daher die selbe sein wie die beim erstmaligen Abschicken der Anmeldung. Die Module werden durch index keys angegeben, welche der Reihenfolge des Ursprünglichen aufbaus der Module kommt
(siehe `/fahrten/:fahrtenId/modules`)

#### Raw JSON

```json
{
  "pageData": {
    "0": {
      "datenschutz": true,
      "fahrtenConditions": true
    },
    "1": {
      "persons": [
        {
          "address": "Musterstr. 19",
          "birthday": "2001-04-03T00:00:00.000Z",
          "bookingOption": "39",
          "eatingHabits": [
            "1"
          ],
          "firstName": "Lars",
          "gender": "1",
          "lastName": "Krautmacher",
          "permSave": true,
          "plz": "51145",
          "scoutName": "Bär"
        }
      ]
    },
    "2": {
      "personCount": "2",
      "reiseDetails": "1",
      "travelDateTime": "2023-09-28T18:00:00.000",
      "travelType": "3"
    },
    "3": {
      "additionalNotice": "Ehre\nwem\nEhre\nehre"
    }
  }
}
```

#### Module 0: Datenschutz

| Key               | Type    | Description                                |
|-------------------|---------|--------------------------------------------|
| `datenschutz`     | Boolean | Indicates if the user accepted the data protection policy. |
| `fahrtenConditions`| Boolean| Indicates if the user accepted the travel conditions.    |

#### Module 1: Personen

| Key              | Type     | Description                                |
|------------------|----------|--------------------------------------------|
| `persons`        | Array   | An array containing personal details of persons. Each object in the array contains: |
| `adress`         | String   | Address of the person.                     |
| `birthday`       | String   | Date of birth of the person. (ISO format)  |
| `bookingOption`  | String   | Booking option chosen by the person.       |
| `eatingHabits`   | Array   | List of eating habits/preferences.         |
| ... (and so on)  | ...      | ...                                        |

#### Module 2: Travel Details

| Key               | Type    | Description                                |
|-------------------|---------|--------------------------------------------|
| `personCount`     | String  | Number of persons traveling.               |
| `reiseDetails`    | String  | Details about the travel.                  |
| `travelDateTime`  | String  | Date and time of travel (ISO format).      |
| `travelType`      | String  | Type of travel chosen.                     |

#### Module 3: Additional Information

| Key               | Type    | Description                                |
|-------------------|---------|--------------------------------------------|
| `additionalNotice`| String  | Any additional notes provided by the user. |

## Endpoint: GET `/fahrten/:fahrtenId/modules`

### Overview

Der API Endpoint dient dazu die Module einer Anmeldung abzurufen um so den Anmeldeprozess dynamisch aufzubauen und anzuzeigen. Der gesamte Prozess wird durch das Backend durch diese API gesteuert.

### Response Format

Die API gibt ein Array von Objekten zurück. Jedes Objekt steht für ein Modul und damit für eine Seite des Anmeldeprozesses. Für den Aufbau eines Moduls siehe Abschnitt "Module".

#### Raw JSON
```json
[
  {
    "title": "Datenschutz",
    "introText": "Am Ende bekommst du eine Bestätigungs-Email. Nur mit dieser E-Mail ist deine Anmeldung erfolgreich abgeschlossen. Du kannst deine Anmeldung nach dem Absenden noch bis zum 12.11.2023 verändern und jederzeit angucken.",
    "formFields": [
      {
        "type": "booleanAttribute",
        "id": "datenschutz",
        "label": "Ich stimme zu meine Daten bis zum Ende der Fahrt zu speichern.",
        "required": true
      },
      {
        "type": "conditionsAttribute",
        "id": "fahrtenConditions",
        "label": "Ich habe die Fahrtenbedinungen gelesen und stimme ihnen hiermit zu.",
        "linkUrl": "stammgalaxias.de/fahrtenbedinungen",
        "required": true
      }
    ]
  },
  {
    "title": "Personen",
    "introText": "",
    "formFields": []
  },
  {
    "title": "Anreise",
    "introText": "Kleiner Test hier und da",
    "formFields": [
      {
        "type": "travelAttribute",
        "id": "testAnreise",
        "label": "Anreise",
        "required": true
      }
    ]
  },
  {
    "title": "Zusätzliche Bemerkung",
    "introText": " Möchstest du der Lagerleitung noch etwas mitgeben? ",
    "formFields": [
      {
        "type": "textAttribute",
        "id": "additionalNotice",
        "label": "Zusätzliche Nachricht",
        "required": true
      }
    ]
  },
  {
    "title": "Zusammenfassung",
    "introText": "",
    "formFields": [
      {
        "type": "booleanAttribute",
        "id": "verbindlicheAnmeldung",
        "label": "Hier mit möchte ich die genannten Personen verbindlich zu dieser Fahrt anmelden.",
        "required": true
      }
    ]
  }
]
```

## Endpoint: GET `/persons`

### Overview

Der API Endpoint dient dazu alle dauerhaft gespeicherten Personen abzurufen. Neue Personen werden am Ende des Anmeldeprozesses über das pageData Object von `/fahrten/:fahrtenId/anmeldung`

### Response Format

Die API gibt ein Array von Objekten zurück. Jedes Objekt steht für eine dauerhaft gespeicherte Person. Die Struktur ist im Grunde Selbsterklärend.

#### Raw JSON
```json
[
  {
    "permSave": true,
    "firstName": "Lars",
    "lastName": "Krautmacher",
    "scoutName": "Bär",
    "birthday": "2001-04-03T00:00:00.000Z",
    "gender": "1",
    "eatingHabits": ["1"],
    "adress": "Bartholomäusstr. 19",
    "plz": "51145"
  },
  {
    "permSave": true,
    "firstName": "Hannah",
    "lastName": "Becker",
    "scoutName": null,
    "birthday": "2001-04-03T00:00:00.000Z",
    "gender": "1",
    "eatingHabits": ["1"],
    "adress": "Bartholomäusstr. 19",
    "plz": "51145"
  }
]
```

## Endpoint: GET `/fahrten`

### Overview

Der API Endpoint dient dazu alle veröffentlichten für die individuelle Person sichtbaren Fahrten anzuzeigen. Das Format ist das selbe wie in der Vue App.

### Response Format

Die API gibt ein Array von Objekten zurück. Jedes Objekt steht für eine dauerhaft anzuzeigende Fahrt.

#### Raw JSON
```json
[
  {
    "id": "bfc564dd-8588-40bf-8ee1-fdb4dc240742",
    "createdAt": "2023-06-21T19:20:59.187755+02:00",
    "updatedAt": "2023-08-12T15:15:15.155859+02:00",
    "status": "expired",
    "name": "Ring Rhein Lippe Sippenaktion 2023",
    "shortDescription": "Ring Rhein Lippe Sippenaktion 2023",
    "longDescription": "<p>Hallo und Herzlich Willkommen zum Ring-Sippen-Tippel vom Ring Rhein Lippe. </p><p><br></p><p>Die Sippenaktion findet vom 25.08.2023-27.08.2023 statt.</p><p><br></p><p>Wir freuen uns auf alle die sich anmelden und mitkommen!</p>",
    "icon": null,
    "location": {
      "id": 3,
      "name": "Pfadfinderzeltplatz",
      "description": "",
      "zipCode": {
        "zipCode": "24852",
        "city": "Eggebek"
      },
      "address": "Tüdal 1",
      "distance": 442.07460178655384
    },
    "startDate": "2023-08-25T18:00:00+02:00",
    "endDate": "2023-08-27T13:00:00+02:00",
    "registrationDeadline": "2023-08-11T23:59:00+02:00",
    "registrationStart": "2023-05-25T00:00:00+02:00",
    "lastPossibleUpdate": "2023-08-24T18:00:00+02:00",
    "bookingOptions": [
      {
        "id": 13,
        "name": "Standard",
        "description": "",
        "price": "15.00",
        "bookableFrom": null,
        "bookableTill": null,
        "maxParticipants": 0,
        "startDate": null,
        "endDate": null,
        "event": "bfc564dd-8588-40bf-8ee1-fdb4dc240742",
        "tags": []
      },
      {
        "id": 14,
        "name": "Nur Samstag",
        "description": "",
        "price": "5.00",
        "bookableFrom": null,
        "bookableTill": "2023-08-25T18:00:00+02:00",
        "maxParticipants": 0,
        "startDate": null,
        "endDate": null,
        "event": "bfc564dd-8588-40bf-8ee1-fdb4dc240742",
        "tags": []
      }
    ],
    "existingRegister": null
  },
  {
    "id": "55b24e63-4e8f-4a56-8be5-52e7c7991a25",
    "createdAt": "2023-09-18T12:22:05.130118+02:00",
    "updatedAt": "2023-09-18T12:22:05.130136+02:00",
    "status": "pending",
    "name": "Test-Lager",
    "shortDescription": "Test-Lager",
    "longDescription": "<p>Einladungtext für Test-Lager für Lars</p>",
    "icon": null,
    "location": {
      "id": 8,
      "name": "Wiese am Rheinufer",
      "description": "Große Wiese direkt am Rheinufer",
      "zipCode": {
        "zipCode": "53859",
        "city": "Niederkassel"
      },
      "address": "-",
      "distance": 8.046241967850868
    },
    "startDate": "2023-11-18T18:00:00+01:00",
    "endDate": "2023-11-19T13:00:00+01:00",
    "registrationDeadline": "2023-11-11T23:59:59+01:00",
    "registrationStart": "2023-08-18T00:00:00+02:00",
    "lastPossibleUpdate": "2023-11-17T18:00:00+01:00",
    "bookingOptions": [
      {
        "id": 39,
        "name": "Standard",
        "description": "",
        "price": "17.00",
        "bookableFrom": null,
        "bookableTill": null,
        "maxParticipants": 0,
        "startDate": null,
        "endDate": null,
        "event": "55b24e63-4e8f-4a56-8be5-52e7c7991a25",
        "tags": []
      }
    ],
    "existingRegister": null
  }
]
```

## Module
Module sind der Kern des Anmeldeprozesses der APP, da der Anmeldeprozess je nach Fahrt dynamisch durch die im Backend erstellten Modul-Objekte aufgebaut werden.

### Modul JSON Aufbau

```json
  {
    "title": "Anreise",
    "introText": "Kleiner Test hier und da",
    "formFields": [
      {
        "type": "travelAttribute",
        "id": "testAnreise",
        "label": "Anreise",
        "required": true
      }
    ]
  }
```

Module haben 3 keys, die wie folgt aussehen:

| Key               | Type   | Description                                |
|-------------------|--------|--------------------------------------------|
| `title`           | String | Der Titel des Moduls der oben auf der Card angezeigt wird |
| `introText`       | String | Quasi der "subTitle", also der Text der kleiner unter dem title angezeigt wird                |
| `formFields`      | Array  | Die FormFields (Attributes) die in dem Modul angezeigt werden sollen      |

### formFields
Damit ein Modul auch Attribute hat und etwas anzeigen kann werden in dem `formField` Array die FormFields eingetragen die im Modul angezeigt werden sollen. Deshalb hier jetzt eine Übersicht über alle `formFields`und ihre möglichen Attribute:

##### `stringAttribute`
Das StringAttribute ist ein einfacher StringInput. Die Standardvalidierung lässt nur Buchstaben zu.

| Key               | Type   | Description                                |
|-------------------|--------|--------------------------------------------|
| `type`*           | String | Der Typ des FormFields, in dem Fall `stringAttribute`|
| `id`*             | String | Ein unique identifier für das Feld. Die ID muss unique im Scope aller Module sein |
| `label`*          | String | Ein Text, der die geforderte Eingabe beschreibt |
| `required`        | bool   | Bestimmt, ob ein Element verpflichtend ist. Standardmäßig: `true`|
| `regex`           | String | Ein regulärer Ausdruck, um den Inhalt des Feldes zu validieren |
| `regexError`      | String | Die Fehlermeldung, die angezeigt wird, wenn die Validierung des regulären Ausdrucks fehlschlägt |
---
**Note** Keys mit * sind zwingend erforderlich

##### `booleanAttribute`
Das BooleanAttribute ist ein einfaches Ein-Aus Schalter Feld.

| Key            | Type   | Description                                                                                     |
|----------------|--------|-------------------------------------------------------------------------------------------------|
| `type`*        | String | Der Typ des FormFields, in dem Fall `booleanAttribute`                                          |
| `id`*          | String | Ein unique identifier für das Feld. Die ID muss unique im Scope aller Module sein               |
| `label`*       | String | Ein Text, der die geforderte Eingabe beschreibt                                                 |
| `required`     | bool   | Bestimmt, ob ein Element verpflichtend ist. Standardmäßig: `true`                               |
| `initialValue` | bool   | Bestimmt, ob der Schalter Standardmäßig ein oder aus sein soll. Standrad: `false                |
---
**Note** Keys mit * sind zwingend erforderlich

##### `integerAttribute`
Das StringAttribute ist ein einfacher StringInput. Die Standardvalidierung lässt nur integer zu.

| Key            | Type   | Description                                                                                    |
|----------------|--------|------------------------------------------------------------------------------------------------|
| `type`*        | String | Der Typ des FormFields, in dem Fall `integerAttribute`                                         |
| `id`*          | String | Ein unique identifier für das Feld. Die ID muss unique im Scope aller Module sein              |
| `label`*       | String | Ein Text, der die geforderte Eingabe beschreibt                                                |
| `regex`        | String | Ein regulärer Ausdruck, um den Inhalt des Feldes zu validieren. Beginnt immer mit `r`           |
| `regexError`   | String | Die Fehlermeldung, die angezeigt wird, wenn die Validierung des regulären Ausdrucks fehlschlägt |
---
**Note** Keys mit * sind zwingend erforderlich

##### `dateTimeAttribute`
Das StringAttribute ist ein einfacher StringInput. Die Standardvalidierung lässt nur integer zu.

| Key            | Type     | Description                                                                      |
|----------------|----------|----------------------------------------------------------------------------------|
| `type`*        | String | Der Typ des FormFields, in dem Fall `dateTimeAttribute`                          |
| `id`*          | String | Ein unique identifier für das Feld. Die ID muss unique im Scope aller Module sein |
| `label`*       | String | Ein Text, der die geforderte Eingabe beschreibt                                  |
| `required`     | bool     | Gibt an, ob das Feld verpflichtend ist                                           |
| `inputType`    | InputType| Der Typ der Eingabe (See flutter_form_builder docs). Standard `InputType.date`   |
| `formatString` | String   | Das Format in dem die DateTime gespeichert werden soll. Standard: `"yyyy-MM-dd"`              |
---
**Note** Keys mit * sind zwingend erforderlich

##### `textAttribute`
Das textAttribute ist einfaches multiline Textfeld. Das Textfeld hat keine Validierung.

| Key            | Type   | Description                                                                                     |
|----------------|--------|-------------------------------------------------------------------------------------------------|
| `type`*        | String | Der Typ des FormFields, in dem Fall `textAttribute`                                          |
| `id`*          | String | Ein unique identifier für das Feld. Die ID muss unique im Scope aller Module sein               |
| `label`*       | String | Ein Text, der die geforderte Eingabe beschreibt                                                 |
| `required`     | bool   | Bestimmt, ob ein Element verpflichtend ist. Standardmäßig: `true`                               |
---
**Note** Keys mit * sind zwingend erforderlich

##### `travelAttribute`
Das textAttribute ist einfaches multiline Textfeld. Das Textfeld hat keine Validierung.

| Key            | Type     | Description                                                                      |
|----------------|----------|----------------------------------------------------------------------------------|
| `type`*        | String | Der Typ des FormFields, in dem Fall `dateTimeAttribute`                          |
| `id`*          | String | Ein unique identifier für das Feld. Die ID muss unique im Scope aller Module sein |
| `label`*       | String | Ein Text, der die geforderte Eingabe beschreibt                                  |
---
**Note** Keys mit * sind zwingend erforderlich

##### `conditionsAttribute`
Das conditionsAttribute ist ein booleanInput der zusätzlich einen Link und einen Text anzeigen kann. Er wird benutzt um Fahrtenbedingungen anzuzeigen und zuzustimmen.

| Key         | Type   | Description                                                                       |
|-------------|--------|-----------------------------------------------------------------------------------|
| `type`*     | String | Der Typ des FormFields, in dem Fall `conditionsAttribute`                           |
| `id`*       | String | Ein unique identifier für das Feld. Die ID muss unique im Scope aller Module sein |
| `label`*    | String | Ein Text, der die geforderte Eingabe beschreibt                                   |
| `required`  | bool   | Gibt an, ob das Feld verpflichtend ist. Standardmäßig `true`                      |
| `urlString` | String | Ein String der die URL angibt, welche zu den Fahrtenbedingungen führt.            |
| `introText` | String | Ein String der einen Text über dem Switch und dem Link anzeigt                    |
---
**Note** Keys mit * sind zwingend erforderlich
