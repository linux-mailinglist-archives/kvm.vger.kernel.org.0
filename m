Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5ED14328B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 20:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgATTn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 14:43:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59687 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgATTn1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 14:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579549405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VTqpjA5GA7gYa91oDRULWOFt2VzDjQR3x+cfcyYPfd8=;
        b=XF0PzpLkNpDlI9x8zj9mIkAWn49KPC5EdZ8FZcb9hhWxOqySznmpgTcPgKlp70f/DZJiXO
        jiSk25hLr8JeUg5UECXFizDaBwGgUE+DBtV+Aw02207B/Pt3N+FTGyJ02x916hAendGBDz
        w5PYUPeewmHCr1dQlG4GSiGrD6VwIvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-XZz3UEhWMfGWy5VvkoMV5A-1; Mon, 20 Jan 2020 14:43:21 -0500
X-MC-Unique: XZz3UEhWMfGWy5VvkoMV5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8996D800D50
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 19:43:20 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-78.gru2.redhat.com [10.97.116.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DA235C1BB;
        Mon, 20 Jan 2020 19:43:16 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com
Subject: [kvm-unit-tests v2 1/2] README: Fix markdown formatting
Date:   Mon, 20 Jan 2020 16:43:09 -0300
Message-Id: <20200120194310.3942-2-wainersm@redhat.com>
In-Reply-To: <20200120194310.3942-1-wainersm@redhat.com>
References: <20200120194310.3942-1-wainersm@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are formatting issues that prevent README.md
from being rendered correctly in a browser. This
patch fixes the following categories of issues:

- blocks which aren't indented correctly;
- texts wrapped in <> which need escape, or
  be replaced with another thing.

Also some inline commands are marked with ``.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
---
 README.md | 72 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/README.md b/README.md
index 1a9a4ab..367c92a 100644
--- a/README.md
+++ b/README.md
@@ -13,12 +13,11 @@ To create the test images do:
     ./configure
     make
=20
-in this directory. Test images are created in ./<ARCH>/*.flat
+in this directory. Test images are created in ./ARCH/\*.flat
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
@@ -26,7 +25,7 @@ To create and use standalone tests do:
     (go to somewhere)
     ./some-test
=20
-'make install' will install all tests in PREFIX/share/kvm-unit-tests/tes=
ts,
+`make install` will install all tests in PREFIX/share/kvm-unit-tests/tes=
ts,
 each as a standalone test.
=20
=20
@@ -42,39 +41,40 @@ or:
=20
 to run them all.
=20
-To select a specific qemu binary, specify the QEMU=3D<path>
+By default the runner script searches for a suitable qemu binary in the =
system.
+To select a specific qemu binary though, specify the QEMU=3Dpath/to/bina=
ry
 environment variable:
=20
     QEMU=3D/tmp/qemu/x86_64-softmmu/qemu-system-x86_64 ./x86-run ./x86/m=
sr.flat
=20
 To select an accelerator, for example "kvm" or "tcg", specify the
-ACCEL=3D<name> environment variable:
+ACCEL=3Dname environment variable:
=20
     ACCEL=3Dkvm ./x86-run ./x86/msr.flat
=20
 # Unit test inputs
=20
-Unit tests use QEMU's '-append <args...>' parameter for command line
+Unit tests use QEMU's '-append args...' parameter for command line
 inputs, i.e. all args will be available as argv strings in main().
 Additionally a file of the form
=20
-KEY=3DVAL
-KEY2=3DVAL
-...
+    KEY=3DVAL
+    KEY2=3DVAL
+    ...
=20
-may be passed with '-initrd <file>' to become the unit test's environ,
-which can then be accessed in the usual ways, e.g. VAL =3D getenv("KEY")
-Any key=3Dval strings can be passed, but some have reserved meanings in
+may be passed with '-initrd file' to become the unit test's environ,
+which can then be accessed in the usual ways, e.g. VAL =3D getenv("KEY")=
.
+ Any key=3Dval strings can be passed, but some have reserved meanings in
 the framework. The list of reserved environment variables is below
=20
- QEMU_ACCEL            ... either kvm or tcg
- QEMU_VERSION_STRING   ... string of the form `qemu -h | head -1`
- KERNEL_VERSION_STRING ... string of the form `uname -r`
+    QEMU_ACCEL                   either kvm or tcg
+    QEMU_VERSION_STRING          string of the form `qemu -h | head -1`
+    KERNEL_VERSION_STRING        string of the form `uname -r`
=20
 Additionally these self-explanatory variables are reserved
=20
- QEMU_MAJOR, QEMU_MINOR, QEMU_MICRO, KERNEL_VERSION, KERNEL_PATCHLEVEL,
- KERNEL_SUBLEVEL, KERNEL_EXTRAVERSION
+    QEMU_MAJOR, QEMU_MINOR, QEMU_MICRO, KERNEL_VERSION, KERNEL_PATCHLEVE=
L,
+    KERNEL_SUBLEVEL, KERNEL_EXTRAVERSION
=20
 # Guarding unsafe tests
=20
@@ -85,42 +85,48 @@ host. kvm-unit-tests provides two ways to handle test=
s like those.
     unittests.cfg file. When a unit test is in the nodefault group
     it is only run when invoked
=20
-    a) independently, arch-run arch/test
-    b) by specifying any other non-nodefault group it is in,
-       groups =3D nodefault,mygroup : ./run_tests.sh -g mygroup
-    c) by specifying all tests should be run, ./run_tests.sh -a
+     a) independently, `ARCH-run ARCH/test`
+
+     b) by specifying any other non-nodefault group it is in,
+        groups =3D nodefault,mygroup : `./run_tests.sh -g mygroup`
+
+     c) by specifying all tests should be run, `./run_tests.sh -a`
=20
  2) Making the test conditional on errata in the code,
+    ```
     if (ERRATA(abcdef012345)) {
         do_unsafe_test();
     }
+    ```
=20
     With the errata condition the unsafe unit test is only run
     when
=20
-    a) the ERRATA_abcdef012345 environ variable is provided and 'y'
-    b) the ERRATA_FORCE environ variable is provided and 'y'
-    c) by specifying all tests should be run, ./run_tests.sh -a
+    a) the ERRATA_abcdef012345 environment variable is provided and 'y'
+
+    b) the ERRATA_FORCE environment variable is provided and 'y'
+
+    c) by specifying all tests should be run, `./run_tests.sh -a`
        (The -a switch ensures the ERRATA_FORCE is provided and set
         to 'y'.)
=20
-The errata.txt file provides a mapping of the commits needed by errata
+The ./errata.txt file provides a mapping of the commits needed by errata
 conditionals to their respective minimum kernel versions. By default,
 when the user does not provide an environ, then an environ generated
-from the errata.txt file and the host's kernel version is provided to
+from the ./errata.txt file and the host's kernel version is provided to
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
+See ./ARCH/README for architecture specific documentation.
=20
 ## Style
=20
--=20
2.23.0

