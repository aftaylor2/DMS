# DMS
Deads Mans Switch<br />
by Andrew Taylor < ataylor@phr3ak.com ><br />
Based on idea proposed by Viktor Petersson - http://bit.ly/1CkN4by<br />
<br />
<h3>Notes</h3>
Intended to be used on a system with full disk encryption. Currently this project is only a Proof of Concept.
However, I recently found a more complete project: https://github.com/defuse/swatd <br />

<br />
<h3>Description</h3>
Protects your private data by performing predetermined actions when you are suddenly separated from your device.<br />

A file is created containing randomly generated data. The file is copied to an external DMS (such as a usb drive attached to the wrist via lanyard). The script monitors the file on the DMS. If the DMS is removed or the checksum does not match, predetermined actions are taken.
