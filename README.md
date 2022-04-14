# 📸 PiBoCa / **Pi** **Bo**dy **Ca**mera
Et lite prosjekt med kamera tilkoblet Raspberry Pi med gPhoto2 og behandling med GraphicsMagick. Styrt fra iPhone-appen Snarveier (Shortcuts).

---

*This repo is currently only in norwegian, but do you want an english description? Let me know! This project is mainly created for private use, but I will be happy to distribute code for others who want to use it.*

---

## Pågående utvikling
Dette er et prosjekt som er i aktiv utvikling fra tid til annen. Skriptet er i kladdestadie med kommentarer og to-do-list av ting som skal gjøres og/eller optimaliseres. Ved bruk av skriptet slik det er nå, skjer på eget ansvar.

Koden er for tiden litt primitiv grunnet begrenset kunnskap av bash skripting, men det viktigste er at det virker til formålet. Ønsker å bli bedre kjent med bash skripting og tar gjerne imot pull request med forbedringer.

## Formålet
Dette skriptet (les: verktøyet) er en del av et prosjekt jeg jobber med.  Verktøyet er en del av målet mitt for å gå ned i vekt, kombinert med aktivitet, trening og kosthold, med råd og veiledning fra lege og ernæringsfysiolog. Både for å motivere meg selv til å gå ned, og lære mer av bash med skripting.

Motivasjonen med å lage verktøyet er å dokumentere prosessen med å ta bilde av meg selv i helfigur, i over lengre tid. Som fotograf og koder med OCD, var målet å bygge et oppsett som kan ta ordentlig bilde hver gang.

Når det skal tas bilde, får man mulighet til å justere posisjonen opp mot forrige bilde man tok tidligere, før man tar bildet.

I over lengre perioder vil man sitte med mengder av bilder som viser prosessen av vektreduksjonen. Herfra er det bare kreativiteten som setter grenser med bruk av bildene. 

### Planer på sikt:
Har ambisjoner med skriptet. Mye av tiden har gått til å bli bedre kjent med bash skripting som egentlig er en liten del av hele idéen med verktøyet. Den morsomme delen av verktøyet er ikke engang skriptet enda.

- Importere helsedata fra Apple Health med klartekst i txt, csv eller json.
    - Vekt, BMI, kroppsfett, muskelmasse, benmasse, vann i kroppen. Med dato/tidspunkt og endringer siden sist. 
- Lage timelapse med ffmpeg, for hele eller begrenset periode.
- Generere grafer med flere punkter fra helse data.


### Oppsett
Tok i bruk det jeg hadde liggende tilgjengelig hjemme, og har naturligvis valgt til bruk og behov. 

#### Maskinvarer som ble satt opp til prosjektet:
- Raspberry Pi 3 Model B Rev 1.2
    - Raspberry Pi OS > Bullseye (2021-10-30)
- Canon PowerShot G9
    - AC strømadapter
    - USB kabel

#### Nødvendige programmer for å kjøre skriptet:
- gphoto2 > 2.5.27.1
    - libgphoto2 > 2.5.22
- GraphicsMagick > 1.3.35 (2020-02-23)

#### Ytterlige oppsett
Til dette oppsettet er fokuset å gjøre det så enkelt som mulig å betjene PiBoCa med iPhone for å fyre av fotograferingen. Med hjelp av Snarveier/Shortcuts, denne delen . Denne biten kan 

- Kablet eller WiFi tilkobling
- Kamera stativ
- iOS app Snarveier (Shortcuts)