GNU Privacy Guard 2.2
--
https://www.gnupg.org/

https://www.gnupg.org/documentation/index.html

https://www.gnupg.org/gph/en/manual/book1.html

NAME
--
       gpg - OpenPGP encryption and signing tool

SYNOPSIS
--
       gpg [--homedir dir] [--options file] [options] command [args]

DESCRIPTION
--
       gpg  is  the OpenPGP part of the GNU Privacy Guard (GnuPG). It is a tool to provide digital encryption and signing services using the OpenPGP standard. gpg features complete key management and all the bells and whistles you would expect from  a  full  OpenPGP implementation.

       There  are  two main versions of GnuPG: GnuPG 1.x and GnuPG 2.x.  GnuPG 2.x supports modern encryption algorithms and thus should be preferred over GnuPG 1.x.  You only need to use GnuPG 1.x if your platform doesn’t support GnuPG 2.x, or you need support  for some features that GnuPG 2.x has deprecated, e.g., decrypting data created with PGP‐2 keys.

       If you are looking for version 1 of GnuPG, you may find that version installed under the name gpg1.


Generate a new key pair using the current default parameters.  This is the standard command to create a new key.  In addition  to  the  key a revocation certificate is created and stored in the ‘openpgp‐revocs.d’ directory below the GnuPG home directory.

       gpg ‐‐gen‐key

Generate a new key pair with dialogs for all options.  This is an extended version of ‐‐generate‐key.

       gpg ‐‐full‐gen‐key

Making and verifying signatures
--
A digital signature certifies and timestamps a document. If the document is subsequently modified in any way, a verification of the signature will fail. A digital signature can serve the same purpose as a hand-written signature with the additional benefit of being tamper-resistant. The GnuPG source distribution, for example, is signed so that users can verify that the source code has not been modified since it was packaged.

Creating and verifying signatures uses the public/private keypair in an operation different from encryption and decryption. A signature is created using the private key of the signer. The signature is verified using the corresponding public key. For example, Alice would use her own private key to digitally sign her latest submission to the Journal of Inorganic Chemistry. The associate editor handling her submission would use Alice's public key to check the signature to verify that the submission indeed came from Alice and that it had not been modified since Alice sent it. A consequence of using digital signatures is that it is difficult to deny that you made a digital signature since that would imply your private key had been compromised.

The command-line option --sign is used to make a digital signature. The document to sign is input, and the signed document is output.

       alice% gpg --output doc.sig --sign doc

       You need a passphrase to unlock the private key for
       user: "Alice (Judge) <alice@cyb.org>"
       1024-bit DSA key, ID BB7576AC, created 1999-06-04

       Enter passphrase: 
The document is compressed before signed, and the output is in binary format.
Given a signed document, you can either check the signature or check the signature and recover the original document. To check the signature use the --verify option. To verify the signature and extract the document use the --decrypt option. The signed document to verify and recover is input and the recovered document is output.

       blake% gpg --output doc --decrypt doc.sig
       gpg: Signature made Fri Jun  4 12:02:38 1999 CDT using DSA key ID BB7576AC
       gpg: Good signature from "Alice (Judge) <alice@cyb.org>"

Clearsigned documents
--
A common use of digital signatures is to sign usenet postings or email messages. In such situations it is undesirable to compress the document while signing it. The option --clearsign causes the document to be wrapped in an ASCII-armored signature but otherwise does not modify the document.

       alice% gpg --clearsign doc

       You need a passphrase to unlock the secret key for
       user: "Alice (Judge) <alice@cyb.org>"
       1024-bit DSA key, ID BB7576AC, created 1999-06-04

       -----BEGIN PGP SIGNED MESSAGE-----
       Hash: SHA1

       [...]
       -----BEGIN PGP SIGNATURE-----
       Version: GnuPG v0.9.7 (GNU/Linux)
       Comment: For info see http://www.gnupg.org

       iEYEARECAAYFAjdYCQoACgkQJ9S6ULt1dqz6IwCfQ7wP6i/i8HhbcOSKF4ELyQB1
       oCoAoOuqpRqEzr4kOkQqHRLE/b8/Rw2k
       =y6kj
       -----END PGP SIGNATURE-----

Detached signatures
--
A signed document has limited usefulness. Other users must recover the original document from the signed version, and even with clearsigned documents, the signed document must be edited to recover the original. Therefore, there is a third method for signing a document that creates a detached signature. A detached signature is created using the --detach-sig option.

       alice% gpg --output doc.sig --detach-sig doc

       You need a passphrase to unlock the secret key for
       user: "Alice (Judge) <alice@cyb.org>"
       1024-bit DSA key, ID BB7576AC, created 1999-06-04

       Enter passphrase: 
       Both the document and detached signature are needed to verify the signature. The --verify option can be to check the signature.

       blake% gpg --verify doc.sig doc
       gpg: Signature made Fri Jun  4 12:38:46 1999 CDT using DSA key ID BB7576AC
       gpg: Good signature from "Alice (Judge) <alice@cyb.org>"


--
--
PS /home/zbook> gpg --full-generate-key
gpg (GnuPG) 2.2.40; Copyright (C) 2022 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
  (14) Existing key from card
Your selection? 
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (3072) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: Muthu Ramadoss
Email address: muthu.ramadoss@gmail.com
Comment: IntelliBitz
You selected this USER-ID:
    "Muthu Ramadoss (IntelliBitz) <muthu.ramadoss@gmail.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? 
Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: directory '/home/zbook/.gnupg/openpgp-revocs.d' created
gpg: revocation certificate stored as '/home/zbook/.gnupg/openpgp-revocs.d/7E9935707672CE253E32CF408E1E773D7DFADC8C.rev'
public and secret key created and signed.

pub   rsa4096 2024-03-13 [SC]
      7E9935707672CE253E32CF408E1E773D7DFADC8C
uid                      Muthu Ramadoss (IntelliBitz) <muthu.ramadoss@gmail.com>
sub   rsa4096 2024-03-13 [E]

PS /home/zbook> gpg --list-keys        
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
/home/zbook/.gnupg/pubring.kbx
------------------------------
pub   rsa4096 2024-03-13 [SC]
      7E9935707672CE253E32CF408E1E773D7DFADC8C
uid           [ultimate] Muthu Ramadoss (IntelliBitz) <muthu.ramadoss@gmail.com>
sub   rsa4096 2024-03-13 [E]

PS /home/zbook> gpg --list-secret-keys --keyid-format=long
/home/zbook/.gnupg/pubring.kbx
------------------------------
sec   rsa4096/8E1E773D7DFADC8C 2024-03-13 [SC]
      7E9935707672CE253E32CF408E1E773D7DFADC8C
uid                 [ultimate] Muthu Ramadoss (IntelliBitz) <muthu.ramadoss@gmail.com>
ssb   rsa4096/D93CED216D2BDA0B 2024-03-13 [E]

PS /home/zbook> gpg --armor --export 8E1E773D7DFADC8C     
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
X4HE+wtVqRZwgokaN51TfM3LYg==
=PY4K
-----END PGP PUBLIC KEY BLOCK-----
