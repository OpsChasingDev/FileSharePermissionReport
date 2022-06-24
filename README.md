# FileSharePermissionReport
A project to produce a comprehensive report of Windows domain users and their accessibility to shared folders.

## Lucidchart Specifications
[Specifications Diagram](https://lucid.app/lucidchart/8a13d5da-a0d5-4388-8f82-5143644f4314/edit?viewport_loc=-1752%2C913%2C4039%2C1940%2C0_0&invitationId=inv_c4833466-4fce-49fe-b34a-301052770740#)

## Concept Desired End Result
At the time of this edit, I'm working towards getting the final result (the presentable information) in such a form whereby each share analyzed on the netework will have its own csv file created to store information on access.  Access information will be broken down into columns of plain English access types associated with each domain user, such as the below:

| User        | Read | Write | Create | Delete | Full Control |
|-------------|------|-------|--------|--------|--------------|
| nfury       | yes  | yes   | yes    | yes    | yes          |
| srogers     | no   | no    | no     | no     | no           |
| nromanoff   | yes  | no    | no     | no     | no           |
| bbanner     | yes  | yes   | no     | no     | no           |