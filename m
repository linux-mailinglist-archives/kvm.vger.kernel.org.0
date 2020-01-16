Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC513FB47
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 22:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388836AbgAPVVB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 16:21:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58134 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731198AbgAPVVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 16:21:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579209659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CnJdiWKNpePsvTLrp2v2Ngi9pPBH1s+lxHBCjP93pVU=;
        b=cGSRaHV94MznzED05+ncUOGt4Dj7KHiXAuNu4RSCVLgDKdSGYwQkGWnTt+SamdFZ9VBRV0
        aiLMWnvRDxh3N5xu+0tcFUuXptq1BSzGjyheJ6dz1YGRi5We5tSlgq31xasOtQf4vZkB2E
        d50PTD5ENmM0vJ0lSG/iq9xYVatmzMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-clv3_kXAM9uJgUL_ipgtYQ-1; Thu, 16 Jan 2020 16:20:58 -0500
X-MC-Unique: clv3_kXAM9uJgUL_ipgtYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52F821800D48
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 21:20:57 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-88.gru2.redhat.com [10.97.116.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 188D588867;
        Thu, 16 Jan 2020 21:20:55 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [kvm-unit-tests] README: fix markdown formatting and general improvements
Date:   Thu, 16 Jan 2020 18:20:54 -0300
Message-Id: <20200116212054.4041-1-wainersm@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are some formatting fixes on this change:
- Some blocks weren't indented correctly;
- Some statements needed escape.

Also the text is improved in some ways:
- Variables and options are bold now;
- Files path are set to italic;
- Inline commands are marked;
- Added a section about the tests configuration file.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
---
 See the results here: https://github.com/wainersm/kvm-unit-tests/tree/do=
cs

 README.md | 100 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 55 insertions(+), 45 deletions(-)

diff --git a/README.md b/README.md
index 1a9a4ab..07c5a82 100644
--- a/README.md
+++ b/README.md
@@ -13,12 +13,11 @@ To create the test images do:
     ./configure
     make
=20
-in this directory. Test images are created in ./<ARCH>/*.flat
+in this directory. Test images are created in *./\<ARCH\>/\*.flat*
=20
 ## Standalone tests
=20
-The tests can be built as standalone
-To create and use standalone tests do:
+The tests can be built as standalone. To create and use standalone tests=
 do:
=20
     ./configure
     make standalone
@@ -26,8 +25,8 @@ To create and use standalone tests do:
     (go to somewhere)
     ./some-test
=20
-'make install' will install all tests in PREFIX/share/kvm-unit-tests/tes=
ts,
-each as a standalone test.
+They are created in *./tests*. Or run `make install` to install all test=
s in
+*PREFIX/share/kvm-unit-tests/tests*, each as a standalone test.
=20
=20
 # Running the tests
@@ -42,85 +41,96 @@ or:
=20
 to run them all.
=20
-To select a specific qemu binary, specify the QEMU=3D<path>
+By default the runner script searches for a suitable qemu binary in the =
system.
+To select a specific qemu binary though, specify the **QEMU=3D\<path\>**
 environment variable:
=20
     QEMU=3D/tmp/qemu/x86_64-softmmu/qemu-system-x86_64 ./x86-run ./x86/m=
sr.flat
=20
 To select an accelerator, for example "kvm" or "tcg", specify the
-ACCEL=3D<name> environment variable:
+**ACCEL=3D\<name\>** environment variable:
=20
     ACCEL=3Dkvm ./x86-run ./x86/msr.flat
=20
-# Unit test inputs
+# Tests suite configuration
=20
-Unit tests use QEMU's '-append <args...>' parameter for command line
-inputs, i.e. all args will be available as argv strings in main().
-Additionally a file of the form
+Given that each test case may need specific runtime configurations as, f=
or
+example, extra QEMU parameters and limited time to execute, the
+runner script reads those information from a configuration file found
+at *./\<ARCH\>/unittests.cfg*. This file also contain the group of tests=
 which
+can be ran with the script's **-g** option.
+
+## Unit test inputs
=20
-KEY=3DVAL
-KEY2=3DVAL
-...
+Unit tests use QEMU's **-append \<args...\>** parameter for command line
+inputs, i.e. all args will be available as *argv* strings in *main()*.
+Additionally a file of the form
=20
-may be passed with '-initrd <file>' to become the unit test's environ,
-which can then be accessed in the usual ways, e.g. VAL =3D getenv("KEY")
-Any key=3Dval strings can be passed, but some have reserved meanings in
-the framework. The list of reserved environment variables is below
+    KEY=3DVAL
+    KEY2=3DVAL
+    ...
=20
- QEMU_ACCEL            ... either kvm or tcg
- QEMU_VERSION_STRING   ... string of the form `qemu -h | head -1`
- KERNEL_VERSION_STRING ... string of the form `uname -r`
+may be passed with **-initrd \<file\>** to become the unit test's enviro=
n,
+which can then be accessed in the usual ways, e.g. `VAL =3D getenv("KEY"=
)`.
+ Any *key=3Dval* strings can be passed, but some have reserved meanings =
in
+the framework. The list of reserved environment variables is:
=20
-Additionally these self-explanatory variables are reserved
+    QEMU_ACCEL                   either kvm or tcg
+    QEMU_VERSION_STRING          string of the form `qemu -h | head -1`
+    KERNEL_VERSION_STRING        string of the form `uname -r`
=20
- QEMU_MAJOR, QEMU_MINOR, QEMU_MICRO, KERNEL_VERSION, KERNEL_PATCHLEVEL,
- KERNEL_SUBLEVEL, KERNEL_EXTRAVERSION
+Additionally these self-explanatory variables are reserved: *QEMU\_MAJOR=
*, *QEMU\_MINOR*, *QEMU\_MICRO*, *KERNEL\_VERSION*, *KERNEL\_PATCHLEVEL*,=
 *KERNEL\_SUBLEVEL*, *KERNEL\_EXTRAVERSION*.
=20
 # Guarding unsafe tests
=20
 Some tests are not safe to run by default, as they may crash the
 host. kvm-unit-tests provides two ways to handle tests like those.
=20
- 1) Adding 'nodefault' to the groups field for the unit test in the
-    unittests.cfg file. When a unit test is in the nodefault group
+ 1) Adding **nodefault** to the groups field for the unit test in the
+    *unittests.cfg* file. When a unit test is in the *nodefault* group
     it is only run when invoked
=20
-    a) independently, arch-run arch/test
-    b) by specifying any other non-nodefault group it is in,
-       groups =3D nodefault,mygroup : ./run_tests.sh -g mygroup
-    c) by specifying all tests should be run, ./run_tests.sh -a
+     a. independently, `<ARCH>-run <ARCH>/<TEST>.flat`
+
+     b. by specifying any other non-nodefault group it is in,
+        *groups =3D nodefault,mygroup* : `./run_tests.sh -g mygroup`
+
+     c. by specifying all tests should be run, `./run_tests.sh -a`
=20
  2) Making the test conditional on errata in the code,
+    ```
     if (ERRATA(abcdef012345)) {
         do_unsafe_test();
     }
-
+    ```
     With the errata condition the unsafe unit test is only run
     when
=20
-    a) the ERRATA_abcdef012345 environ variable is provided and 'y'
-    b) the ERRATA_FORCE environ variable is provided and 'y'
-    c) by specifying all tests should be run, ./run_tests.sh -a
-       (The -a switch ensures the ERRATA_FORCE is provided and set
+    a) the *ERRATA\_abcdef012345* environment variable is provided and '=
y'
+
+    b) the **ERRATA_FORCE** environment variable is provided and 'y'
+
+    c) by specifying all tests should be run, `./run_tests.sh -a`
+       (The **-a** switch ensures the **ERRATA_FORCE** is provided and s=
et
         to 'y'.)
=20
-The errata.txt file provides a mapping of the commits needed by errata
+The *./errata.txt* file provides a mapping of the commits needed by erra=
ta
 conditionals to their respective minimum kernel versions. By default,
 when the user does not provide an environ, then an environ generated
-from the errata.txt file and the host's kernel version is provided to
+from the *./errata.txt* file and the host's kernel version is provided t=
o
 all unit tests.
=20
 # Contributing
=20
 ## Directory structure
=20
-    .:				configure script, top-level Makefile, and run_tests.sh
-    ./scripts:		helper scripts for building and running tests
-    ./lib:			general architecture neutral services for the tests
-    ./lib/<ARCH>:	architecture dependent services for the tests
-    ./<ARCH>:		the sources of the tests and the created objects/images
+    .:                  configure script, top-level Makefile, and run_te=
sts.sh
+    ./scripts:          helper scripts for building and running tests
+    ./lib:              general architecture neutral services for the te=
sts
+    ./lib/<ARCH>:       architecture dependent services for the tests
+    ./<ARCH>:           the sources of the tests and the created objects=
/images
=20
-See <ARCH>/README for architecture specific documentation.
+See *./\<ARCH\>/README* for architecture specific documentation.
=20
 ## Style
=20
@@ -129,7 +139,7 @@ existing files should be consistent with the existing=
 style. For new
 files:
=20
   - C: please use standard linux-with-tabs, see Linux kernel
-    doc Documentation/process/coding-style.rst
+    doc *Documentation/process/coding-style.rst*
   - Shell: use TABs for indentation
=20
 Exceptions:
@@ -142,7 +152,7 @@ Patches are welcome at the KVM mailing list <kvm@vger=
.kernel.org>.
=20
 Please prefix messages with: [kvm-unit-tests PATCH]
=20
-You can add the following to .git/config to do this automatically for yo=
u:
+You can add the following to *.git/config* to do this automatically for =
you:
=20
     [format]
         subjectprefix =3D kvm-unit-tests PATCH
--=20
2.23.0

