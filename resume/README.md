This directory contains the various versions of my resume created over the
years.

The primary editable file is GurjeetResume.odt. To update the resume, edit this
file using LibreOffice, and then generate a PDF using LibreOffice's 'Export as
PDF' feature.

After updating the .odt copy, use the following command to generate the PDF copy
of the resume.

    soffice --convert-to pdf GurjeetResume.odt

If needed, split the PDF file to share smaller version of the resume. Use the
`pdfseparate`, and its counterpart `pdfcunite`, to create the smaller file.
These utilities can be installed using the `poppler` package.

    TMP_STR=$(date +resume-split-%Y%m%d%H%M%S) # Deliberately not using mktemp
    pdfseparate -f 1 -l 3 GurjeetResume.pdf "$TMPDIR/$TMP_STR.%d.pdf"
    pdfunite "$TMPDIR/$TMP_STR."{1,2,3}.pdf GurjeetResume-short.pdf

If you install `odt2txt`, then you can use th e`git diff` command to see the edits
made in the resume ODT file. Just add the following section to `~/.gitconfig`.

```
[diff "odf"]
        binary = true
        textconv = odt2txt
```
