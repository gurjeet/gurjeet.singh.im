This directory contains the various versions of my resume created over the
years.

The primary editable file is GurjeetResume.odt. To update the resume, edit this
file using LibreOffice, and then generate a PDF using LibreOffice's 'Export as
PDF' feature.

After updating the .odt copy, use the following command to generate the PDF copy
of the resume.

    soffice --convert-to pdf GurjeetResume.odt

If you install `odt2txt`, then you can use `git diff` command to see the edits
made in the above file. Just add the following section to `~/.gitconfig`.

```
[diff "odf"]
        binary = true
        textconv = odt2txt
```
